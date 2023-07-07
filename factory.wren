// title:   Continous Factory
// author:  unicorns of DEATH
// desc:    Conveyor belt puzzle game
// site:    https://github.com/UnicornsOfDeath/continuous-factory
// license: MIT License
// version: 1.1
// script:  wren
// saveid:  continuous-factory
// pal:     system-mini-16

import "random" for Random

var WIDTH=240
var HEIGHT=136
var MAP_W=30
var MAP_H=17
var LEVEL=0
var TRICKY_LEVELS=7
var LEVEL_MAP=[
    0,
    1,
    2,
    3,
    11,
    4,
    5,
    13, // gateturn
    17, // reverse
    19, // gateturn,reverse
    9,  // cross
    7,  // return
    6,  // gateturn,shortpath
    16, // misdirection,shortpath
    22, // gateturn,reverse
    10, // block,misdirection
    15, // misdirection,reverse
    12, // gateturn
    23,
    14, // misdirection,reverse
    21, // gateturn
    20, // block,misdirection,cross
    8,  // gateturn,shortpath
    18, // misdirection,gateturn,reverse
]
var COLOR_BG=5
var COLOR_KEY=9
var MUSSPLASH=0
var MUSGAME=1
var MUSGAMEPLAYING=false
var MUSTITLE=2
var MUSTEMPO=100
var MUSSPD=3
var FPS=60
var MUSBEATTICKS=FPS*60/MUSTEMPO*MUSSPD/6
var SFXNEXT=1
var SFXDOTASK=2
var SFXSPAWN=3
var SFXCOMPLETE=4
var SFXINCOMPLETE=5
var SFXLEVELEND=6
var RANDOM=Random.new()
var FONTH=5
var IDLETICKS=3600

var UP=0
var RIGHT=1
var DOWN=2
var LEFT=3

// VRAM ADDRESSES
var PALETTE_MAP=0x3FF0

// BUTTONS

var BTN_UP=0
var BTN_DOWN=1
var BTN_LEFT=2
var BTN_RIGHT=3
var BTN_A=4
var BTN_B=5
var BTN_X=6
var BTN_Y=7

// MAP/TASK IDS
var EMPTY_TILE=0
var IN_TILE=16
var OUT_TILE=17
var CONV_R=18
var CONV_L=19
var CONV_U=20
var CONV_D=21
var ERASER=22
var DISK=32
var APPLE=33
var GLASS=34
var WIN=48
var LINUX=49
var HAMMER=50
var DISK_GATE=80
var APPLE_GATE=81
var GLASS_GATE=82
var WIN_GATE=83
var LINUX_GATE=84
var HAMMER_GATE=85

// JOB

var JOB_SPAWN_TICKS=104

var MOVE_TICKS=50

// Map data, for resetting
var MAPRESETS=[]
var AVAILABLEGATES=[]

// Music instruments
// 48 - BD
// 49 - HH
// 50 - soft
// 52 - lead2
// 53 - BD + bass
// 54 - stick + bass short
// 57 - splash bass
// 58 - string
// 59 - pad
// 60 - piano
// 55 - piano delay8
// 56 - piano delay4
// 63 - piano delay2
// 61 - bass
// 62 - bass short

// Star colors, brightest to darkest
var COLORS=[3,2,1,0]
var SPEEDMIN=0.001
var SPEEDMAX=0.02

class Utils {
    static rot(x,y,ca,sa){
        return [x*ca-y*sa,x*sa+y*ca]
    }
    static aspr(id,x,y,colorkey,sx,sy,flip,rotate,w,h,ox,oy,shx1,shy1,shx2,shy2){
        // Draw a sprite using two textured triangles.
        // Apply affine transformations: scale, shear, rotate, flip

        // scale / flip
        if((flip%2)==1){
            sx=-sx
        }
        if(flip>=2){
            sy=-sy
        }
        ox=ox*-sx
        oy=oy*-sy
        // shear / rotate
        shx1=shx1*-sx
        shy1=shy1*-sy
        shx2=shx2*-sx
        shy2=shy2*-sy
        var rr=rotate*Num.pi/180
        var sa=rr.sin
        var ca=rr.cos
        var r1=rot(ox+shx1,oy+shy1,ca,sa)
        var r2=rot(w*8*sx+ox+shx1,oy+shy2,ca,sa)
        var r3=rot(ox+shx2,h*8*sy+oy+shy1,ca,sa)
        var r4=rot(w*8*sx+ox+shx2,h*8*sy+oy+shy2,ca,sa)
        var x1 = x + r1[0]
        var y1 = y + r1[1]
        var x2 = x + r2[0]
        var y2 = y + r2[1]
        var x3 = x + r3[0]
        var y3 = y + r3[1]
        var x4 = x + r4[0]
        var y4 = y + r4[1]
        // UV coords
        var u1=(id%16)*8
        var v1=(id/16).floor*8
        var u2=u1+w*8
        var v2=v1+h*8

        TIC.ttri(x1,y1,x2,y2,x3,y3,u1,v1,u2,v1,u1,v2,0,colorkey)
        TIC.ttri(x3,y3,x4,y4,x2,y2,u1,v2,u2,v2,u2,v1,0,colorkey)
    }

    static easeOutBack(x){
        var c1=1.70158
        var c3=c1+1
        return 1+c3*(x-1).pow(3)+c1*(x-1).pow(2)
    }

    static mapX(){
        return (LEVEL_MAP[LEVEL]%8)*MAP_W
    }
    static mapY(){
        return (LEVEL_MAP[LEVEL]/8).floor*MAP_H
    }

    static drawWindow(x,y,w,h) {
        TIC.rectb(x,y,w,h,0)
        x=x+1
        y=y+1
        w=w-2
        h=h-2
        TIC.rectb(x,y,w-1,h-1,3)
        TIC.rectb(x+1,y+1,w-1,h-1,1)
        x=x+1
        y=y+1
        w=w-2
        h=h-2
        TIC.rect(x,y,w,h,2)
    }

    // Draw a tiled sprite inside a clipping area
    static drawtileclip(x,y,w,h,drawf,cx,cy,cw,ch){
        TIC.clip(cx,cy,cw,ch)
        // Find start of tile drawing
        var xstart=x
        while(xstart>cx){
            xstart=xstart-w
        }
        while(xstart+w<=cx){
            xstart=xstart+w
        }
        var ystart=y
        while(ystart>cy){
            ystart=ystart-h
        }
        while(ystart+h<=cy){
            ystart=ystart+h
        }
        // Draw tiled
        y=ystart
        while(y<cy+ch){
            x=xstart
            while(x<cx+cw){
                drawf.call(x,y)
                x=x+w
            }
            y=y+h
        }
        TIC.clip()
    }
}

class Star {
    construct new(){
        _x=WIDTH/2
        _y=HEIGHT/2
        _dx=RANDOM.float()-0.5
        _dy=RANDOM.float()-0.5
        var n=norm(_dx,_dy)
        _dx=n[0]
        _dy=n[1]
        // Square rand to skew more slow stars
        var s=RANDOM.float()*RANDOM.float()*(SPEEDMAX-SPEEDMIN)+SPEEDMIN
        _ddx=_dx*s
        _ddy=_dy*s
        _dx=_dx*s
        _dy=_dy*s
        _mag=RANDOM.float()+0.5
    }

    distance(x1,y1,x2,y2){
        var dx=x1-x2
        var dy=y1-y2
        return (dx*dx+dy*dy).sqrt
    }

    norm(x,y){
        var d=distance(x,y,0,0)
        if (d==0){
            return [1,0]
        }
        return [x/d,y/d]
    }

    update(){
        _x=_x+_dx
        _y=_y+_dy
        _dx=_dx+_ddx
        _dy=_dy+_ddy
    }

    alive{_x>=0&&_x<=WIDTH&&_y>=0&&_y<=HEIGHT}

    draw(){
        var dfactor=((_x-WIDTH/2).abs+(_y-HEIGHT/2).abs)/(WIDTH/2)
        var sfactor=(_dx.abs+_dy.abs-SPEEDMIN)/(SPEEDMAX-SPEEDMIN)/25
        var mfactor=(dfactor*sfactor).sqrt
        var i=COLORS.count-(mfactor*_mag*COLORS.count).floor.min(COLORS.count-1)-1
        TIC.pix(_x,_y,COLORS[i])
    }
}

class StarGenerator {
    construct new(n,interval){
        _n=n
        _interval=interval
        _counter=0
        _stars=[]
    }

    update(){
        // Add new stars
        if(_stars.count<_n && _counter==0){
            _stars.add(Star.new())
            _counter=_interval
        }
        if(_counter>0){
            _counter=_counter-1
        }
        // Move stars
        _stars.each{|s|
            s.update()
            // Remove stars that are out of bounds
            if(!s.alive){
                _stars.remove(s)
            }
        }
    }

    draw(){
        _stars.each{|s|
            s.draw()
        }
    }
}

class ChunkyFont {

    static init_() {
        __SYM_MAP={
            "}":0,
            "{":1,
            "^":2,
            "<":3,
            "=":4,
            ">":5,
            "]":6,
            "[":7,
            "r":16,
            "?":17,
            "|":18,
            "Y":19,
            "o":20,
            "T":21,
            "P":22,
            "7":23,
            "6":32,
            "j":33,
            "v":34,
            "m":35,
            "_":37,
            "L":38,
            "J":39,
        }

        __WIDTH=8
        __HEIGHT=8

        __COLOR1=1
        __COLOR2=2

        __LETTERS={
            "a":[
                "",
                "r?",
                "6v"
            ],
            "b":[
                "^",
                "]?",
                "Lj"
            ],
            "c":[
                "",
                "r>",
                "6>"
            ],
            "d":[
                " ^",
                "r[",
                "6J"
            ],
            "e":[
                "",
                "r?",
                "6>"
            ],
            "f":[
                "r>",
                "]>",
                "v"
            ],
            "g":[
                "",
                "r7",
                "6[",
                "<j"
            ],
            "h":[
                "^",
                "]?",
                "vv"
            ],
            "i":[
                "o",
                "^",
                "v"
            ],
            "j":[
                " o",
                " ^",
                " |",
                "<j"
            ],
            "k":[
                "^",
                "]>",
                "vo"
            ],
            "l":[
                "^",
                "|",
                "v"
            ],
            "m":[
                "",
                "PT?",
                "vvv"
            ],
            "n":[
                "",
                "P?",
                "vv"
            ],
            "o":[
                "",
                "r?",
                "6j"
            ],
            "p":[
                "",
                "P?",
                "]j",
                "v"
            ],
            "q":[
                "",
                "r7",
                "6[",
                " v"
            ],
            "r":[
                "",
                "P>",
                "v"
            ],
            "s":[
                "",
                "r>",
                "<j"
            ],
            "t":[
                "^",
                "]>",
                "6>"
            ],
            "u":[
                "",
                "^^",
                "6J"
            ],
            "v":[
                "",
                "^^",
                "Lj"
            ],
            "w":[
                "",
                "^^^",
                "6mj"
            ],
            "x":[
                "",
                "oo",
                "oo"
            ],
            "y":[
                "",
                "^^",
                "6[",
                "<j"
            ],
            "z":[
                "",
                "<?",
                "6>"
            ],
            "A":[
                "r=?",
                "]=[",
                "v v"
            ],
            "B":[
                "P=?",
                "]={",
                "L=j"
            ],
            "C":[
                "r=>",
                "|",
                "6=>"
            ],
            "D":[
                "P=?",
                "| |",
                "L=j"
            ],
            "E":[
                "P=>",
                "]=>",
                "L=>"
            ],
            "F":[
                "P=>",
                "]>",
                "v"
            ],
            "G":[
                "r=>",
                "|<7",
                "6=J"
            ],
            "H":[
                "^ ^",
                "]=[",
                "v v"
            ],
            "I":[
                "T",
                "|",
                "_"
            ],
            "J":[
                "  ^",
                "^ |",
                "6=j"
            ],
            "K":[
                "^ ^",
                "]={",
                "v v"
            ],
            "L":[
                "^",
                "|",
                "L=>"
            ],
            "M":[
                "PY7",
                "|v|",
                "v v"
            ],
            "N":[
                "P?^",
                "|||",
                "v6J"
            ],
            "O":[
                "r=?",
                "| |",
                "6=j"
            ],
            "P":[
                "P=?",
                "]=j",
                "v"
            ],
            "Q":[
                "r=?",
                "| |",
                "6=o"
            ],
            "R":[
                "P=?",
                "]={",
                "v v"
            ],
            "S":[
                "r=>",
                "6=?",
                "<=j"
            ],
            "T":[
                "<T>",
                " |",
                " v"
            ],
            "U":[
                "^ ^",
                "| |",
                "6=j"
            ],
            "V":[
                "^ ^",
                "|rj",
                "Lj"
            ],
            "W":[
                "^ ^",
                "|^|",
                "6mj"
            ],
            "X":[
                "o o",
                " o",
                "o o"
            ],
            "Y":[
                "^ ^",
                "6Yj",
                " v"
            ],
            "Z":[
                "<=7",
                "r=j",
                "L=>"
            ]
        }
        __WIDTHADJ={
            "j":-1
        }
    }

	construct new(x,y) {
		_x=x
		_y=y
    }

	ch(c) {
		var xadj=__WIDTHADJ[c]
		if (xadj==null) {
			xadj=0
        }
		var width=0
		var y=_y
		for (row in __LETTERS[c]) {
			var x=_x+xadj*__WIDTH
			var rowwidth=0
			var hasletter=false
			for (i in 0...row.count) {
				var letter=row[i]
				if (letter!=" ") {
					hasletter=true
					TIC.spr(__SYM_MAP[letter]+128,x,y,COLOR_KEY)
                }
				if (hasletter) {
					rowwidth=rowwidth+1
                }
				x=x+__WIDTH
            }
			y=y+__HEIGHT
			width=width.max(rowwidth)
        }
		_x=_x+(width+xadj)*__WIDTH
    }

	s(s) {
		var x=_x
		var readcolor=0
		for (i in 0...s.count) {
			var c=s[i]
			if (c=="\n") {
				_x=x
				_y=_y+__HEIGHT*4
            } else if (c=="^") {
				readcolor=1
				resetpalette()
            } else if (readcolor==1) {
				var color=tonumberfromhex(c)
				TIC.poke4(PALETTE_MAP * 2 + __COLOR1, color)
				readcolor=2
            } else if (readcolor==2) {
				var color=tonumberfromhex(c)
				TIC.poke4(PALETTE_MAP * 2 + __COLOR2, color)
				readcolor=0
            } else {
				ch(c)
            }
        }
		resetpalette()
    }

    tonumberfromhex(c) {
        if (c=="a") { 
            return 0xa 
        } else if (c=="b") {
            return 0xb 
        } else if (c=="c") { 
            return 0xc 
        } else if (c=="d") {
            return 0xd 
        } else if (c=="e") { 
            return 0xe 
        } else if (c=="f") {
            return 0xf 
        } else { 
            return Num.fromString(c)
        }
    }

	resetpalette() {
		TIC.poke4(PALETTE_MAP * 2 + __COLOR1, __COLOR1)
		TIC.poke4(PALETTE_MAP * 2 + __COLOR2, __COLOR2)
    }
}

ChunkyFont.init_()

var MOUSESPEED=1.5
var CURSORPOINT=[1,0,0]
var CURSORHAND=[2,2,1]
var CURSORNO=[3,3,3]
var CURSORROTIDX=4

class Mouse {
    construct new(speed){
        _speed=speed
        _mouse=TIC.mouse()
        _prev=_mouse
        _mx=_mouse[0]
        _my=_mouse[1]
        _mxp=_mouse[0]
        _myp=_mouse[1]
        _cursor=CURSORPOINT[0]
        _dx=CURSORPOINT[1]
        _dy=CURSORPOINT[2]
        _tooltip=""
        _tooltipticks=0
    }

    mouse{_mouse}
    x{_mouse[0]}
    y{_mouse[1]}
    left{_mouse[2]}
    right{_mouse[4]}
    moved{_mouse[0]!=_prev[0]||_mouse[1]!=_prev[1]}
    leftp{left&&!_prev[2]}
    rightp{right&&!_prev[4]}
    cursor=(value){
        _cursor=value[0]
        _dx=value[1]
        _dy=value[2]
    }

    setTooltip(value){
        if(_tooltip!=value){
            _tooltip=value
            _tooltipticks=0
        }
    }

    update(){
        _prev=_mouse
        _mxp=_mx
        _myp=_my
        _mouse=TIC.mouse()
        _mx=_mouse[0]
        _my=_mouse[1]
        if(_mx==_mxp&&_my==_myp){
            // Mouse did not move, use existing mouse position
            _mouse[0]=_prev[0]
            _mouse[1]=_prev[1]
            if(TIC.btn(BTN_UP)){
                _mouse[1]=(_mouse[1]-_speed).max(0)
            }else if(TIC.btn(BTN_DOWN)){
                _mouse[1]=(_mouse[1]+_speed).min(HEIGHT)
            }
            if(TIC.btn(BTN_LEFT)){
                _mouse[0]=(_mouse[0]-_speed).max(0)
            }else if(TIC.btn(BTN_RIGHT)){
                _mouse[0]=(_mouse[0]+_speed).min(WIDTH)
            }
        }
        if(TIC.btn(BTN_A)){
            _mouse[2]=true
        }
        if(TIC.btn(BTN_B)){
            _mouse[4]=true
        }
        _tooltipticks=_tooltipticks+1
        TIC.poke(0x3FFB,0)  // hide cursor
    }

    draw(){
        if(_cursor!=0){
            TIC.spr(_cursor,x-_dx,y-_dy,COLOR_KEY)
        }
        var tooltiplen=((_tooltipticks-60)/3).floor.min(_tooltip.count-1)
        if(tooltiplen>0){
            var s=_tooltip[0..tooltiplen]
            var len=TIC.print(s,WIDTH,HEIGHT,0,false,1,true)
            var drawx=(x-_dx+5).min(WIDTH-(len+1))
            TIC.rect(drawx,y-_dy+6,len+1,6,3)
            TIC.print(s,drawx+1,y-_dy+6,0,false,1,true)
        }
    }
}

var MOUSE=Mouse.new(MOUSESPEED)

class Button {
    x { _x }
    x=(value) { _x=value }
    y { _y }
    y=(value) { _y=value }
    width { _width }
    height { _height }
    wasDown { _wasDown }
    wasDown=(value){_wasDown=value}
    hover { _hover }
    hover=(value){_hover=value}
    clicked {_active&&_clicked}
    tooltip=(value){_tooltip=value}
    fillcolor{_fillcolor}
    fillcolor=(value){_fillcolor=value}
    bordercolor{_bordercolor}
    bordercolor=(value){_bordercolor=value}

  construct new(x,y,w,h,bordercolor,fillcolor,hovercolor,shadecolor){
    _x=x
    _y=y
    _bordercolor=bordercolor
    _fillcolor=fillcolor
    _hovercolor=hovercolor
    _shadecolor=shadecolor
    _width=w
    _height=h
    _wasDown=false
    _wasHover=false
    _hover=false
    _clicked=false
    _tooltip=null
    _active=false
  }

  draw() {
    // border
    TIC.rectb(x,y,width,height,_bordercolor)
    // highlight/shading
    TIC.rectb(x+1,y+1,width-2,height-2,_hovercolor)
    TIC.rectb(x+2,y+2,width-3,height-3,_shadecolor)
    // fill
    var fc=_fillcolor
    if (_hover){
        fc=_hovercolor
        if (wasDown){
            fc=_shadecolor
        }
    }
    TIC.rect(x+2,y+2,width-4,height-4,fc)
  }
 
  update() {
    // Wait until mouse buttons released before allowing button interaction
    if(!MOUSE.left&&!MOUSE.right){
        _active=true
    }
    if(!_active){
        return
    }
    _hover=MOUSE.x>=_x && MOUSE.x<=_x+_width && MOUSE.y>=_y && MOUSE.y<=_y+_height
    // Change cursor: hand
    if (_hover){
        MOUSE.cursor=CURSORHAND
        if(_tooltip){
            MOUSE.setTooltip(_tooltip)
        }
    }
    // Clicking on release
    _clicked=false
    if (!MOUSE.left && _hover && _wasHover && _wasDown){
      _clicked=true
    }
    _wasHover=_hover
    _wasDown=MOUSE.left
  }

  reset(){
    _wasHover=false
    _wasDown=false
    _clicked=false
    _active=false
  }
}

class LabelButton is Button {

  construct new(x,y,w,h,label,textcolor,fillcolor,hovercolor,shadecolor){
    super(x,y,w,h,textcolor,fillcolor,hovercolor,shadecolor)
    _label=label
    _textcolor=textcolor
    _textw=TIC.print(label,0,-6)
  }

  label=(value){
    _label=value
    _textw=TIC.print(value,0,-6)
  }
 
  draw() {
    super.draw()
    // label centered
    TIC.print(_label,x+(width-_textw)/2,y+(height-FONTH)/2,_textcolor)
  }
}

class ImageButton is Button {
  construct new(x,y,w,h,sprite,spriteW,spriteH,bordercolor,fillcolor,hovercolor,shadecolor){
    super(x,y,w,h,bordercolor,fillcolor,hovercolor,shadecolor)
    _sprite=sprite
    _spriteW=spriteW
    _spriteH=spriteH
  }
  
  draw() {
    super.draw()
    // sprite centered
    TIC.spr(_sprite,x+(width-_spriteW*8)/2,y+(height-_spriteH*8)/2,COLOR_KEY,1,0,0,_spriteW,_spriteH)
  }
}

class State {
	construct new() {
		_tt=0
		_nextstate=this
    }
    nextstate { _nextstate }
    nextstate=(value) {
        _nextstate=value
    }
    tt { _tt }
    tt=(value) {
        _tt=value
    }
	reset() {
		_tt=0
    }
	update() {
		_tt=_tt+1
        MOUSE.cursor=CURSORPOINT
        MOUSE.update()
    }

	finish() {
        return
    }

	next() {
        return this
    }

	draw() {
        MOUSE.draw()
    }
}

class SkipState is State {
	construct new(grace) {
		super()
		_grace=grace
    }

	finish() {
        TIC.sfx(-1)
		TIC.sfx(SFXNEXT)
    }

    canSkip {tt>_grace}

	next() {
        if (canSkip && (MOUSE.leftp||MOUSE.rightp)) {
			finish()
			nextstate.reset()
			return nextstate
        }
		return this
    }
}

class SplashStateText {
    t { _t }
    tx { _tx }
    construct new(t, tx) {
        _t=t
        _tx=tx
    }                                                              
}

class SplashState is SkipState {

	construct new() {
		super(10)
		_len=250
		_texts=[
			SplashStateText.new(0,"^abu"),
			SplashStateText.new(1,"^abu^cdni"),
			SplashStateText.new(2,"^abu^cdni^abc^cdorns"),
			SplashStateText.new(3,"^abu^cdni^abc^cdorns\n^abo^cdf"),
			SplashStateText.new(4,"^abu^cdni^abc^cdorns\n^abo^cdf^76DEATH"),
        ]
    }

	reset() {
		super.reset()
		TIC.music(MUSSPLASH,-1,-1,false)
        MUSGAMEPLAYING=false
    }

	draw() {
		TIC.cls(COLOR_BG)
		var tx=null
		for (text in _texts) {
			if (tt<text.t*MUSBEATTICKS) {
				break
            }
			tx=text.tx
        }
		if (tx!=null) {
			var cf=ChunkyFont.new(50,40)
			cf.s(tx)
        }
		if (tt>5.8*MUSBEATTICKS) {
			drawface(170,36)
        }
		super.draw()
    }

	drawface(x,y) {
        TIC.spr(204,x,y,COLOR_KEY,1,0,0,4,4)
    }

	next() {
		if (tt>=_len) {
			finish()
			nextstate.reset()
			return nextstate
        }
		return super()
    }
}

class LevelButton is LabelButton{
    construct new(x,y,w,h,level,textcolor,fillcolor,hovercolor,shadecolor){
        super(x,y,w,h,"Level %(level+1)",textcolor,fillcolor,hovercolor,shadecolor)
        _level=level
    }
    level{_level}
}

class TitleState is State {
	construct new() {
		super()
        _startbtn=LabelButton.new(80,HEIGHT-45,78,20,"START",0,2,3,1)
        _continuebtn=null
        _creditsbtn=LabelButton.new(85,HEIGHT-18,60,7,"",0,0,0,0)
        _idlecounter=IDLETICKS
    }

    idlestate { _idlestate }
    idlestate=(value) {
        _idlestate=value
    }

	reset() {
		super.reset()
        _levelselecting=false
		TIC.music(MUSTITLE,-1,-1,false)
        MUSGAMEPLAYING=false
        var savelvl=TIC.pmem(0)
        if(savelvl>0){
            _startbtn.x=40
            _continuebtn=LabelButton.new(122,HEIGHT-45,78,20,"LEVEL SELECT",0,2,3,1)
            _levelselectbtns=[]
            for(i in 0..savelvl.max(TRICKY_LEVELS-1)){
                var c1=i<TRICKY_LEVELS?9:2
                var c2=i<TRICKY_LEVELS?8:1
                _levelselectbtns.add(LevelButton.new(39+(i%3)*55,10+(i/3).floor*12,51,12,i,0,c1,3,c2))
            }
            _backbtn=LabelButton.new(80,HEIGHT-26,80,20,"BACK",0,2,3,1)
        }
    }

    next(){
        if(_startbtn.clicked){
            finish()
			nextstate.reset()
			return nextstate
        }
        if(_continuebtn){
            if(_continuebtn.clicked){
                _levelselecting=true
                _continuebtn.reset()
                TIC.sfx(SFXNEXT)
            }
            for(btn in _levelselectbtns){
                if(btn.clicked){
                    LEVEL=btn.level
                    finish()
                    nextstate.reset()
                    return nextstate
                }
            }
            if(_backbtn.clicked){
                _levelselecting=false
                _backbtn.reset()
                TIC.sfx(SFXNEXT)
            }
        }
        if(_idlecounter<=0||_creditsbtn.clicked){
            _creditsbtn.reset()
            finish()
            idlestate.reset()
            return idlestate
        }
        return super.next()
    }

	finish() {
		TIC.sfx(SFXNEXT)
        if(!MUSGAMEPLAYING){
		    TIC.music(MUSGAME,-1,-1,true)
            MUSGAMEPLAYING=true
        }
    }

    update(){
        super.update()
        if(!_levelselecting){
            _startbtn.update()
            if(_continuebtn){
                _continuebtn.update()
            }
            _creditsbtn.update()
            if(!MOUSE.moved){
                _idlecounter=_idlecounter-1
            }else{
                _idlecounter=IDLETICKS
            }
        }else{
            _levelselectbtns.each{|btn|
                btn.update()
            }
            _backbtn.update()
        }
    }

    draw() {
        TIC.cls(0)
        var x=34
        var y=5
        var w=172
        var h=130
        Utils.drawWindow(x,y,w,h)
        if(!_levelselecting){
            y=y+3
            TIC.spr(268,x+60,y,2,2,0,0,4,3)
            y=y+45
            printShadow("CONTINUOUS",x+30,y,0,1,2,false)
            y=y+16
            printShadow("FACTORY",x+30,y,0,1,3,false)
            y=y+50
            printShadow("Copyright (c) UnicornsOfDeath Corp 1985-1993",x+4,y,0,1,1,true)
            y=y+7
            printShadow("All rights reserved.",x+50,y,0,1,1,true)
            _startbtn.draw()
            if(_continuebtn){
                _continuebtn.draw()
            }
        }else{
            _levelselectbtns.each{|btn|
                btn.draw()
            }
            _backbtn.draw()
        }
        super.draw()
    }

    printShadow(text,x,y,color,shadow,scale,small){
		TIC.print(text,x,y+1,shadow,false,scale,small)
		TIC.print(text,x,y,color,false,scale,small)
    }
}

class Rect {
    x { _x }
    y { _y }
    width { _width }
    height { _height }
    left { _x }
    right { _x + width }
    top { _y }
    bottom { _y + height }

    construct new(x,y,width,height) {
        _x=x
        _y=y
        _width=width
        _height=height
    }

    intersects(other) {
        return !(right < other.left || left > other.right || top > other.bottom || bottom < other.top)
    }

    translate(x,y) {
        return Rect.new(_x+x,_y+y,_width,_height)
    }
}

class GameObject {
    x { _x }
    y { _y }
    hitbox { _hitbox }
    x=(value){ _x=value }
    y=(value){ _y=value }

    construct new(x,y) {
        _x=x
        _y=y
    }

    construct new(x,y,hitbox) {
        _x=x
        _y=y
        _hitbox=hitbox
    }

    update(){}

    palset(c0,c1){
        if(c0==null && c1==null){
            for (i in 0..15){
                TIC.poke4(0x3FF0*2+i,i)
            }
        } else {
            TIC.poke4(0x3FF0*2+c0,c1)
        }
    }

    draw() {}

    intersects(other) {
        return _hitbox.translate(x,y).intersects(other.hitbox.translate(other.x,other.y))
    }
}

class StarJob is GameObject {
    construct new(x,y) {
        super(x,y)
        _ticks=0
        _papers=[]
    }
    update(){
        super.update()
        if(_ticks>0){
            _ticks=_ticks-1
        }
        if(_ticks==0){
            _ticks=99
            if(RANDOM.int(5)==0){
                _papers.add(StarPaper.new(x,y+4))
            }
        }
        _papers.each{|p|
            p.update()
            if(!p.alive){
                _papers.remove(p)
            }
        }
    }
    draw() {
        var frame=((99-_ticks)/(100/5)).floor
        var d=((_ticks-10)/100*Num.tau).sin
        TIC.spr(359+frame*32,x,y-d*3,COLOR_KEY,1,0,0,2,2)
        _papers.each{|p|
            p.draw()
        }
    }
}

class StarPaper is GameObject {
    construct new(x,y) {
        super(x,y)
        _ticks=0
        _dx=RANDOM.float()*0.004
        _fps=RANDOM.int(30,90)
    }
    update(){
        super.update()
        _ticks=_ticks+1
    }
    alive{y<HEIGHT}
    draw() {
        var frame=((_ticks%_fps)/(_fps/8)).floor
        var fx=frame%3
        var fy=(frame/3).floor
        var d=_ticks*_ticks
        TIC.spr(393+fx*2+fy*32,x-d*_dx,y+d*0.0035,COLOR_KEY,1,0,0,2,2)
    }
}

class ToolbarButton is ImageButton {
    construct new(sprite,x,y,atooltip){
        super(x,y,14,12,sprite,1,1,0,2,3,1)
        _sprite=sprite
        tooltip=atooltip
    }

    count{AVAILABLEGATES[LEVEL_MAP[LEVEL]][_sprite]}

    draw(){
        // Draw greyed out if not available
        var fillcolorprev=fillcolor
        if(count!=null&&count==0){
            fillcolor=bordercolor
        }
        super.draw()
        fillcolor=fillcolorprev
        if(count!=null){
            TIC.print("%(count)",x-4,y+3,0,false,1,true)
        }
    }

    update() {
        super.update()
        // Disable hover if we have none available
        if(count!=null&&count==0){
            _hover=false
        }
    }
}

class Toolbar {

    selection=(value){_selection=value}
    selection{_selection}
    hover{MOUSE.x>=_x&&MOUSE.x<_x+_w&&MOUSE.y>=_y&&MOUSE.y<_y+_h}
    hoverbutton(){
        for(button in _buttons){
            if(button.value.hover){
                return button.value
            }
        }
        return null
    }

    construct new() {
        _x=WIDTH-20
        _y=13
        _w=25
        _h=HEIGHT-35
        var xpos=_x+6
        var ypos=_y+3
        var dy=13
        _buttons={}
        _selection=null
        for(gateid in [CONV_R,DISK_GATE,APPLE_GATE,GLASS_GATE,WIN_GATE,LINUX_GATE,HAMMER_GATE]){
            if(AVAILABLEGATES[LEVEL_MAP[LEVEL]][gateid]!=null) {
                _buttons[gateid] = ToolbarButton.new(gateid,xpos,ypos,"logic gate")
                if(_selection==null){
                    _selection=gateid
                }
                ypos=ypos+dy
            }
        }
        _buttons[ERASER]=ToolbarButton.new(ERASER,xpos,_y+_h-15,"erase")
    }

    clicked() {
        return _buttons.values.any {|button| button.clicked }
    }

    update(){
        for (button in _buttons) {
            button.value.update()
            if(button.value.clicked) {
                _selection=button.key
                TIC.sfx(SFXNEXT)
            }
        }
    }

    draw() {
        Utils.drawWindow(_x,_y,_w,_h)
        for (button in _buttons) {
            var oldhover=button.value.hover
            var oldwasdown=button.value.wasDown
            if(GameMap.toBaseGate(_selection)==button.key){
                button.value.hover=true
                button.value.wasDown=true
            }
            button.value.draw()
            button.value.hover=oldhover
            button.value.wasDown=oldwasdown
        }
    }
}

class MainState is State {
    construct new() {
		super()
        _map=null
        _buildPhase=true
        _toolbar=null
        _startbtn=null
        _stopbtn=null
        _resetbtn=null
        _speedbtn=null
		_backbtn=LabelButton.new(WIDTH-13,1,12,9,"X",0,7,3,6)
        _fastforward=false
        _failed=false
        _deathticks=60
    }
    winstate { _winstate }
    winstate=(value) {
        _winstate=value
    }
    titlestate { _titlestate }
    titlestate=(value) {
        _titlestate=value
    }

    reset() {
        super.reset()
        _map=GameMap.new(Fn.new { failState() })
        _toolbar=Toolbar.new()
		_startbtn=LabelButton.new(50,1,50,9,"START",0,2,3,1)
		_stopbtn=LabelButton.new(50,1,50,9,"STOP",0,7,3,6)
		_resetbtn=LabelButton.new(105,1,50,9,"RESET",0,7,3,6)
        _speedbtn=LabelButton.new(103,1,20,9,">",0,9,3,8)
        softreset()
    }

    softreset(){
        _map.softreset(false)
        _buildPhase=true
        _fastforward=false
		_failed=false
        _deathticks=60
    }

    update() {
        super.update()

        if (_buildPhase){
            _startbtn.update()
            _resetbtn.update()
            _toolbar.update()
            if(_startbtn.clicked){
                TIC.sfx(SFXNEXT)
                _buildPhase=false
                tt=0
                _map.start()
            }else if(_toolbar.clicked()) {
                TIC.sfx(SFXNEXT)
                // NO-OP
            }else if(_resetbtn.clicked){
                TIC.sfx(SFXNEXT)
                _map.softreset(true)
                _toolbar=Toolbar.new()
            }else{
                var tileX=(MOUSE.x/16).floor
                var tileY=(MOUSE.y/16).floor
                if(MOUSE.leftp) {
                    if(_map.isInBounds(tileX,tileY)){
                        var existingBelt=_map.getConveyorBelt(tileX,tileY)
                        var existingGate=_map.getGate(tileX,tileY)
                        if(_toolbar.selection==ERASER){
                            _map.tryRemoveUserItem(tileX,tileY)
                        }else if(existingBelt!=null) {
                            var dir=(existingBelt.dir+1)%4
                            _map.updateConveyorBeltDir(tileX,tileY,dir)
                            _toolbar.selection=ConveyorBelt.dirToMapTile(dir)
                        } else if(existingGate != null) {
                            var dir=(existingGate.dir+1)%4
                            _map.updateGateDir(tileX,tileY,dir)
                        } else {
                            if(_toolbar.selection==CONV_U) {
                                _map.addConveyorBelt(tileX, tileY, UP)
                            } else if(_toolbar.selection==CONV_D) {
                                _map.addConveyorBelt(tileX, tileY, DOWN)
                            } else if(_toolbar.selection==CONV_L) {
                                _map.addConveyorBelt(tileX, tileY, LEFT)
                            } else if(_toolbar.selection==CONV_R) {
                                _map.addConveyorBelt(tileX, tileY, RIGHT)
                            } else if([DISK_GATE,APPLE_GATE,GLASS_GATE,WIN_GATE,LINUX_GATE,HAMMER_GATE].contains(GameMap.toBaseGate(_toolbar.selection))) {
                                _map.addGate(tileX,tileY,_toolbar.selection)
                            }
                        }
                        TIC.sfx(SFXNEXT)
                    }
                }

                if(MOUSE.rightp) {
                    var currentTile=_map.getTileId(tileX,tileY)
                    if(_map.tryRemoveUserItem(tileX,tileY)){
                        _toolbar.selection=currentTile
                        TIC.sfx(SFXNEXT)
                    }
                }

                // Set mouse cursor based on current tool
                if(_map.isInBounds(tileX,tileY)){
                    var useritem=_map.getTileId(tileX,tileY)
                    if(useritem==0){
                        if(_toolbar.selection==ERASER){
                            // Show nothing
                        }else if(AVAILABLEGATES[LEVEL_MAP[LEVEL]][GameMap.toBaseGate(_toolbar.selection)]==0){
                            MOUSE.cursor=CURSORNO
                        }else{
                            MOUSE.cursor=[_toolbar.selection,3,3]
                        }
                    }else{
                        if(_toolbar.selection==ERASER&&_map.isUserItem(tileX,tileY)){
                            MOUSE.cursor=[ERASER,3,3]
                        }else if(_map.isUserItem(tileX,tileY)){
                            MOUSE.cursor=[((tt/10).floor%4)+CURSORROTIDX,3,3]
                        }
                    }
                    // Set tooltip for current selection
                    if(LEVEL<TRICKY_LEVELS){
                        if(useritem==0){
                            if(_toolbar.selection==ERASER){
                                // Show nothing
                                MOUSE.setTooltip("")
                            }else if(AVAILABLEGATES[LEVEL_MAP[LEVEL]][GameMap.toBaseGate(_toolbar.selection)]==0){
                                // show currently selected tile item
                                MOUSE.setTooltip("not enough")
                            }else{
                                MOUSE.setTooltip("place")
                            }
                        }else{
                            if(_toolbar.selection==ERASER&&_map.isUserItem(tileX,tileY)){
                                MOUSE.setTooltip("erase")
                            }else if(_map.isUserItem(tileX,tileY)){
                                // Rotate/erase item under cursor
                                MOUSE.setTooltip("rotate/erase")
                            }else if(useritem==IN_TILE){
                                MOUSE.setTooltip("source")
                            }else if(useritem==OUT_TILE){
                                MOUSE.setTooltip("sink")
                            }else if(useritem==DISK||useritem==APPLE||useritem==GLASS||useritem==WIN||useritem==LINUX||useritem==HAMMER){
                                MOUSE.setTooltip("factory")
                            }else{
                                MOUSE.setTooltip("")
                            }
                        }
                    }
                }else if(_toolbar.hoverbutton()==null){
                    MOUSE.setTooltip("")
                }
            }
        } else {
            _stopbtn.update()
            if(_stopbtn.clicked){
                softreset()
            }
            _speedbtn.update()
            if(_speedbtn.clicked){
                _fastforward=!_fastforward
                _speedbtn.label=_fastforward?">>":">"
            }
        }
        _backbtn.update()

        if (_failed){
            if (_deathticks>0) {
                _deathticks=_deathticks-1
                if (_deathticks==1) {
                    softreset()
                }
            }
        }

        var ticks=_fastforward?8:1
        for(i in 1..ticks){
            _map.update()
        }
    }

    next() {
        if (_map!=null&&_map.haswon) {
            finish()
            winstate.reset()
            return winstate
        }
        if(_backbtn.clicked){
            TIC.sfx(SFXNEXT)
            finish()
            titlestate.reset()
            return titlestate
        }
		return super()
    }

    finish(){
        // Reset border color
        TIC.vbank(0)
        TIC.poke(0x03FF8,0)
        super.finish()
    }

    failState() {
        _buildPhase=true
        _map.stop()
        _failed = true
    }

    draw() {
        // Draw game border
        var bx=16
        var by=16
        var bw=WIDTH-48
        var bh=HEIGHT-40
        TIC.rect(bx,by,bw,bh,4)
        // inner slope
        TIC.line(bx-1,by-1,bx+bw-1,by-1,0)
        TIC.line(bx-1,by,bx-1,by+bh-1,0)
        TIC.line(bx-1,by+bh,bx+bw-1,by+bh,2)
        TIC.line(bx+bw,by-1,bx+bw,by+bh,2)
        // inner edge
        TIC.line(bx-2,by-2,bx+bw,by-2,1)
        TIC.line(bx-2,by-1,bx-2,by+bh,1)
        TIC.line(bx-2,by+bh+1,bx+bw+1,by+bh+1,3)
        TIC.line(bx+bw+1,by-2,bx+bw+1,by+bh,3)
        // emboss
        TIC.rectb(bx-3,by-3,bw+6,bh+6,2)
        // outer edge
        TIC.line(bx-4,by-4,bx+bw+3,by-4,3)
        TIC.line(bx-4,by-3,bx-4,by+bh+3,3)
        TIC.line(bx-4,by+bh+3,bx+bw+3,by+bh+3,1)
        TIC.line(bx+bw+3,by-4,bx+bw+3,by+bh+3,1)

        _map.draw()

        if(_buildPhase){
            var tileX=(MOUSE.x/16).floor
            var tileY=(MOUSE.y/16).floor
            if(_map.isInBounds(tileX,tileY)){
                var x=tileX*16
                var y=tileY*16
                TIC.spr(494,x,y,COLOR_KEY,1,0,0,2,2)
            }
        }
        // Set border color
        TIC.vbank(0)
        TIC.poke(0x03FF8,_buildPhase?0:9)
        Utils.drawWindow(-2,-2,WIDTH+4,14)
        TIC.print("Level:%(LEVEL+1)",2,3,0,false,1)

        // Draw next jobs window
        Utils.drawWindow(2,HEIGHT-20,WIDTH-4,19)
        TIC.print("Next:",5,HEIGHT-15,0,false,1,true)
        var jx=1.6
        _map.spawnJobs.each{|job|
            job.x=jx
            job.y=7
            job.draw()
            jx=jx+1.2
        }

        if(_buildPhase){
            TIC.print("Build Phase",WIDTH-54,3,0,false,1,true)
            _startbtn.draw()
            _resetbtn.draw()
            _toolbar.draw()
        }else{
            _stopbtn.draw()
            _speedbtn.draw()
            TIC.print("Folders:%(_map.jobsDone)/%(_map.jobsCount)",WIDTH-56,3,0,false,1,true)
        }
        _backbtn.draw()
		super.draw()
    }
}

class DeathState is SkipState {
	construct new() {
		super(60)
    }

	finish() {
        return
    }

    next() {
        finish()
        nextstate.reset()
        return nextstate
    }
}

class WinState is State {
	construct new() {
		super()
        _nextbtn=LabelButton.new(80,HEIGHT-68,80,20,"NEXT",0,2,3,1)
        _flyingjobs=[]
    }
    starstate { _starstate }
    starstate=(value) {
        _starstate=value
    }

	reset() {
		super.reset()
        TIC.sfx(SFXLEVELEND)
    }

	finish() {
    }

    next() {
        if(_nextbtn.clicked){
            finish()
            LEVEL=LEVEL+1
            if (LEVEL==LEVEL_MAP.count) {
                LEVEL=0
                starstate.reset()
                return starstate
            }
            if(LEVEL>TIC.pmem(0)){
                TIC.pmem(0,LEVEL)
            }
            nextstate.reset()
            return nextstate
        }
		return super()
    }

    update(){
        super.update()
        _nextbtn.update()
        if(LEVEL+1==LEVEL_MAP.count){
            if(_flyingjobs.count<10){
                _flyingjobs.add(FlyingJob.new(RANDOM.int(0,WIDTH),RANDOM.int(30,HEIGHT)))
            }
            _flyingjobs.each{|fj|
                fj.update()
                if(fj.isComplete){
                    _flyingjobs.remove(fj)
                }
            }
        }
    }

	draw() {
		TIC.cls(COLOR_BG)
        var x=20
        var y=40
        var w=200
        var h=55
        Utils.drawWindow(x,y,w,h)
        if(LEVEL+1==LEVEL_MAP.count){
            TIC.print("CONGRATULATIONS!",x+7,y+5,0,false,2)
            y=y+14
            TIC.print("Game complete!",x+7,y+5,0,false,1)
            _flyingjobs.each{|fj|
                fj.draw()
            }
        }else{
            TIC.print("LEVEL %(LEVEL+1) COMPLETE",x+7,y+5,0,false,2)
            if(LEVEL+1==TRICKY_LEVELS){
                y=y+14
                TIC.print("Challenging levels ahead!",x+7,y+5,0,false,1)
            }
        }
        _nextbtn.draw()
        super.draw()
    }
}

class HelpState is State {
	construct new() {
		super()
        _read=false
        _startbtn=LabelButton.new(95,HEIGHT-20,50,9,"START",0,2,3,1)
    }

    reset(){
        super.reset()
        _read=LEVEL>0
    }

    next(){
        if(_read||_startbtn.clicked){
            TIC.sfx(SFXNEXT)
            finish()
            nextstate.reset()
            return nextstate
        }
        return super.next()
    }

    finish(){
        _read=true
    }

    update() {
        super.update()
        _startbtn.update()
    }

	draw() {
		TIC.cls(COLOR_BG)
        var x=30
        var y=5
        var w=180
        var h=125
        var fh=FONTH+2
        Utils.drawWindow(x,y,w,h)
		TIC.print("README",x+35,y+3,0,false,3)
        x=x+3
        y=y+25
		TIC.print("Welcome, new team member!",x,y,0,false,1,true)
        y=y+fh
		TIC.print("Please optimize our continuous delivery system!",x,y,0,false,1,true)
        y=y+fh
		TIC.print("JOB FOLDERS with TASKS will appear from the",x,y,0,false,1,true)
        y=y+fh
		TIC.print("YELLOW source.",x,y,0,false,1,true)
        y=y+fh
		TIC.print("Direct them using CONVEYOR BELTS.",x,y,0,false,1,true)
        y=y+fh
		TIC.print("Complete TASKS in each FOLDER using MONITORS.",x,y,0,false,1,true)
        y=y+fh
		TIC.print("Once complete, deliver them to the GREEN SINK.",x,y,0,false,1,true)
        y=y+fh*2
		TIC.print("CLICK to PLACE or ROTATE objects",x,y,0,false,1,true)
        y=y+fh
		TIC.print("RIGHT CLICK to REMOVE",x,y,0,false,1,true)
        y=y+fh*2
		TIC.print("Good luck and SYNERGIZE!",x,y,0,false,1,true)
        _startbtn.draw()
		super.draw()
    }
}

class StarState is State{
    construct new(){
        _stargen=StarGenerator.new(200,1)
        _job=StarJob.new(WIDTH/2-32,HEIGHT*0.6)
    }

    reset(){
        super.reset()
        if(!MUSGAMEPLAYING){
		    TIC.music(MUSGAME,-1,-1,true)
            MUSGAMEPLAYING=true
        }
        MOUSE.cursor=[0,0,0]
    }

    finish(){
        super.finish()
        MOUSE.cursor=CURSORPOINT
    }

    next(){
        if(MOUSE.leftp){
            TIC.sfx(SFXNEXT)
            finish()
            nextstate.reset()
            return nextstate
        }
        return super.next()
    }

    draw() {
        TIC.cls(0)
        _stargen.draw()
        _job.draw()
		super.draw()
    }

    update() {
        super.update()
        _stargen.update()
        _job.update()
    }
}

class ConveyorBelt is GameObject {

    static dirToMapTile(dir) {
        if(dir==UP) {
            return CONV_U
        } else if(dir==DOWN) {
            return CONV_D
        } else if(dir==LEFT) {
            return CONV_L
        } else if(dir==RIGHT) {
            return CONV_R
        }
        return null
    }

    dir {_dir}
    dir=(value) {_dir=value}

    construct new(x,y,dir) {
        super(x*16,y*16,Rect.new(0,0,16,16))
        _dir=dir
        _ticks=0
    }

    draw() {
        var frame=(_ticks/5).floor%4
        if (_dir==DOWN) {
            TIC.spr(288,x,y,COLOR_KEY,1,0,0,2,2)
            var drawf=Fn.new{|x,y|
                TIC.spr(290,x,y,COLOR_KEY,1,0)
            }
            Utils.drawtileclip(x,y+frame,8,8,drawf,x+1,y+2,7,12)
            drawf=Fn.new{|x,y|
                TIC.spr(290,x,y,COLOR_KEY,1,1)
            }
            Utils.drawtileclip(x+8,y+frame,8,8,drawf,x+8,y+2,7,12)
        } else if (_dir==UP) {
            TIC.spr(288,x,y,COLOR_KEY,1,0,0,2,2)
            var drawf=Fn.new{|x,y|
                TIC.spr(291,x,y,COLOR_KEY,1,2)
            }
            Utils.drawtileclip(x,y-frame,8,8,drawf,x+1,y+2,7,12)
            drawf=Fn.new{|x,y|
                TIC.spr(291,x,y,COLOR_KEY,1,3)
            }
            Utils.drawtileclip(x+8,y-frame,8,8,drawf,x+8,y+2,7,12)
        } else if (_dir==LEFT) {
            TIC.spr(320+(frame%2)*2,x,y,COLOR_KEY,1,0,0,2,2)
            var drawf=Fn.new{|x,y|
                TIC.spr(290,x,y,COLOR_KEY,1,0,1)
            }
            Utils.drawtileclip(x-frame,y-1,8,8,drawf,x+1,y+1,14,5)
            drawf=Fn.new{|x,y|
                TIC.spr(290,x,y,COLOR_KEY,1,2,1)
            }
            Utils.drawtileclip(x-frame,y+5,8,8,drawf,x+1,y+6,14,5)
        } else if (_dir==RIGHT) {
            TIC.spr(320+(frame%2)*2,x,y,COLOR_KEY,1,0,0,2,2)
            var drawf=Fn.new{|x,y|
                TIC.spr(291,x,y,COLOR_KEY,1,1,1)
            }
            Utils.drawtileclip(x+frame,y-1,8,8,drawf,x+1,y+1,14,5)
            drawf=Fn.new{|x,y|
                TIC.spr(291,x,y,COLOR_KEY,1,0,3)
            }
            Utils.drawtileclip(x+frame,y+5,8,8,drawf,x+1,y+6,14,5)
        }
    }

    update() {
        _ticks=_ticks+1
    }
}

class InTile is GameObject {
    // Spawns jobs on itself
    construct new(x,y,jobs) {
        super(x*16,y*16,Rect.new(0,0,16,16))
        _ticks=0
        _jobs=jobs
    }

    draw() {
        var frame=(_ticks/8).floor%3
        TIC.spr(328+frame*2,x,y,COLOR_KEY,1,0,0,2,2)
    }

    update() {
        // Returns the job to spawn or null
        _ticks=_ticks+1
        if(_ticks==JOB_SPAWN_TICKS){
            _ticks=0
            if(_jobs.count>0){
                return _jobs.removeAt(0)
            }
        }
        return null
    }
}

class OutTile is GameObject {

    construct new(x,y) {
        super(x*16,y*16,Rect.new(0,0,16,16))
        _ticks=0
    }

    draw() {
        var frame=2-((_ticks/10).floor%3)
        palset(5,9)
        palset(4,8)
        TIC.spr(256+frame*2,x,y,COLOR_KEY,1,0,0,2,2)
        palset(null,null)
    }

    update() {
        _ticks=_ticks+1
    }
}

class Factory is GameObject {
    construct new(x,y,task) {
        super(x*16,y*16,Rect.new(0,0,16,16))
        _task=task
    }

    draw() {
        TIC.spr(262,x,y,COLOR_KEY,1,0,0,2,2)
        TIC.spr(_task,x+4,y+5,COLOR_KEY)
    }

    update() {
    }
}

class Gate is GameObject {

    static tasks() {
        return [DISK,APPLE,GLASS,WIN,LINUX,HAMMER]
    }

    static toMapTile(task,dir) {
        return 64+tasks().indexOf(task)+16*dir
    }

    static new(x,y,tileId) {
        var task=tasks()[tileId%16]
        var dirRow=((tileId-64)/16).floor
        return new(x,y,task,dirRow)
    }

    construct new(x,y,task,dir) {
        super(x*16,y*16,Rect.new(0,0,16,16))
        _ticks=0
        _task=task
        _dir=dir
        _falseDir=(dir+2)%4
    }

    dir {_dir}
    task{_task}
    falseDir{_falseDir}

    passes(job){
        return job.containsTask(_task)
    }

    draw() {
        TIC.spr(264,x,y,COLOR_KEY,1,0,0,2,2)
        TIC.spr(_task,x+4,y+5,COLOR_KEY)
        if((_ticks%30)>8){
            if(dir==RIGHT){
                TIC.spr(266,x+8,y+4,COLOR_KEY)
            }else if(dir==DOWN){
                TIC.spr(267,x+4,y+8,COLOR_KEY)
            }else if(dir==LEFT){
                TIC.spr(283,x,y+8,COLOR_KEY)
            }else{
                TIC.spr(282,x+4,y,COLOR_KEY)
            }
            palset(14,7)
            if(_falseDir==RIGHT){
                TIC.spr(266,x+8,y+4,COLOR_KEY)
            }else if(_falseDir==DOWN){
                TIC.spr(267,x+4,y+8,COLOR_KEY)
            }else if(_falseDir==LEFT){
                TIC.spr(283,x,y+8,COLOR_KEY)
            }else{
                TIC.spr(282,x+4,y,COLOR_KEY)
            }
            palset(null,null)
        }
    }
    update(){
        _ticks=_ticks+1
    }
}

class GameMap {
    
    construct new(killStateFunction) {
        _killStateFunction=killStateFunction
        _started=false
        _time=0
        _userTiles=[EMPTY_TILE,CONV_U,CONV_D,CONV_L,CONV_R]
        _userTiles.addAll((64..69).toList)
        _userTiles.addAll((80..85).toList)
        _userTiles.addAll((96..101).toList)
        _userTiles.addAll((112..117).toList)

        clearTiles()
        for(x in 0..MAP_W/2) {
            for(y in 0..MAP_H/2){
                if(isInBounds(x,y)){
                    var tileId=getTileId(x,y)
                    setTile(x,y,tileId)
                }
            }
        }
        softreset(false)
    }

    time{_time}
    spawnJobs{_spawnJobs}
    jobsCount{_jobsCount}
    jobsDone{_jobsDone}
    haswon{jobsDone==jobsCount&&_flyingjobs.count==0}

    clearTiles(){
        _conveyorBelts=[]
        for(i in 1..MAP_H) {
            _conveyorBelts.add(List.filled(MAP_W, null))
        }
        _factories=[]
        _gates=[]
        for(i in 1..MAP_H) {
            _gates.add(List.filled(MAP_W, null))
        }
    }

    setTile(x,y,tileId){
        if(tileId==IN_TILE){
            _inTile=InTile.new(x,y,_spawnJobs)
        }else if(tileId==OUT_TILE){
            _outTile=OutTile.new(x,y)
        }else if(tileId==CONV_R){
            addConveyorBelt(x,y,RIGHT)
        }else if(tileId==CONV_L){
            addConveyorBelt(x,y,LEFT)
        }else if(tileId==CONV_U){
            addConveyorBelt(x,y,UP)
        }else if(tileId==CONV_D){
            addConveyorBelt(x,y,DOWN)
        }else if(tileId==DISK||tileId==APPLE||tileId==GLASS||tileId==WIN||tileId==LINUX||tileId==HAMMER){
            _factories.add(Factory.new(x,y,tileId))
        }else if(tileId>=64&&tileId<=117&&(tileId%16)<6){
            addGate(x,y,tileId)
        }
        TIC.mset(Utils.mapX()+x,Utils.mapY()+y,tileId)
    }

    softreset(resetTiles) {
        _started=false
        _jobs=[]
        _flyingjobs=[]
        _time=0
        // Load jobs to spawn
        _spawnJobs=[]
        for(x in 0..MAP_W){
            var tasks={}
            for(y in MAP_H-1..0){
                var tileId=getTileId(x,y)
                if(tileId==DISK||tileId==APPLE||tileId==GLASS||tileId==WIN||tileId==LINUX||tileId==HAMMER){
                    if(tasks[tileId]==null){
                        tasks[tileId]=0
                    }
                    tasks[tileId]=tasks[tileId]+1
                }else{
                    break
                }
            }
            if(tasks.count==0){
                // No more jobs
                break
            }
            var job = Job.new(0,0,0,0,tasks)
            job.moveRight()
            job.ticks=MOVE_TICKS
            _spawnJobs.add(job)
        }
        _jobsCount=_spawnJobs.count
        // Reconnect the intile
        for(x in 0..MAP_W/2) {
            for(y in 0..MAP_H/2){
                var tileId=getTileId(x,y)
                if(tileId==IN_TILE){
                    _inTile=InTile.new(x,y,_spawnJobs)
                }
            }
        }
        _jobsDone=0
        if(resetTiles){
            clearTiles()
            var i=0
            for(y in 0..MAP_H/2){
                for(x in 0..MAP_W/2) {
                    if(isInBounds(x,y)){
                        tryRemoveUserItem(x,y)
                        var tileId=MAPRESETS[LEVEL_MAP[LEVEL]][i]
                        setTile(x,y,tileId)
                    }
                    i=i+1
                }
            }
        }
    }

    start() {
        _started=true
        _time=0
    }

    stop() {
        _started=false
        _time=0
    }

    addConveyorBelt(x,y,dir) {
        var currentTile=getTileId(x,y)
        if(!_userTiles.contains(currentTile)) return
        tryRemoveUserItem(x,y)
        var tileId=ConveyorBelt.dirToMapTile(dir)
        if (AVAILABLEGATES[LEVEL_MAP[LEVEL]][CONV_R]&&AVAILABLEGATES[LEVEL_MAP[LEVEL]][CONV_R]>0) {
            _conveyorBelts[x][y]=ConveyorBelt.new(x,y,dir)
            TIC.mset(Utils.mapX()+x,Utils.mapY()+y,tileId)
            updateGateCount(CONV_R,-1)
        }
    }

    getConveyorBelt(x,y) {
        return _conveyorBelts[x][y]
    }

    static toBaseGate(tileId){
        if(tileId==CONV_R||tileId==CONV_L||tileId==CONV_U||tileId==CONV_D){
            return CONV_R
        }
        var x=tileId%16
        var y=(tileId/16).floor
        if(y>=4&&y<=7&&x>=0&&x<=5){
            return 80+x
        }
        return 0
    }

    isInBounds(x,y){
        return x>0&&y>0&&x<13&&y<7
    }

    isUserItem(x,y){
        var currentTile=getTileId(x,y)
        return _userTiles.contains(currentTile)
    }

    tryRemoveUserItem(x,y) {
        // Check out of bounds
        if(!isInBounds(x,y)){
            return false
        }
        var currentTile=getTileId(x,y)
        if(!_userTiles.contains(currentTile)||currentTile==EMPTY_TILE) return false
        currentTile=GameMap.toBaseGate(currentTile)
        if(_conveyorBelts[x][y]!=null){
            // Removing belt
            _conveyorBelts[x][y]=null
        }else if(_gates[x][y]!=null){
            // Removing gate
            _gates[x][y]=null
        }
        updateGateCount(currentTile,1)
        TIC.mset(Utils.mapX()+x,Utils.mapY()+y,EMPTY_TILE)
        return true
    }

    updateConveyorBeltDir(x,y,dir) {
        tryRemoveUserItem(x,y)
        addConveyorBelt(x,y,dir)
    }

    addGate(x,y,tileId) {
        tryRemoveUserItem(x,y)
        var currentTile=getTileId(x,y)
        if(!_userTiles.contains(currentTile)) return
        var baseGate=GameMap.toBaseGate(tileId)
        if (AVAILABLEGATES[LEVEL_MAP[LEVEL]][baseGate] > 0) {
            updateGateCount(baseGate,-1)
            _gates[x][y]=Gate.new(x,y,tileId)
            TIC.mset(Utils.mapX()+x,Utils.mapY()+y,tileId)
        }
    }

    updateGateCount(tileId,d){
        tileId=GameMap.toBaseGate(tileId)
        if(AVAILABLEGATES[LEVEL_MAP[LEVEL]][tileId]!=null){
            AVAILABLEGATES[LEVEL_MAP[LEVEL]][tileId]=AVAILABLEGATES[LEVEL_MAP[LEVEL]][tileId]+d
        }
    }

    getGate(x,y) {
        return _gates[x][y]
    }

    updateGateDir(x,y,dir) {
        var task=_gates[x][y].task
        tryRemoveUserItem(x,y)
        _gates[x][y]=Gate.new(x,y,task,dir)
        var tileId=Gate.toMapTile(task,dir)
        TIC.mset(Utils.mapX()+x,Utils.mapY()+y,tileId)
        updateGateCount(Gate.toMapTile(task,RIGHT),-1)
    }

    hasNoJobAt(x,y){
        var result=true
        _jobs.each { |job|
            if(x==job.x&&y==job.y){
                result=false
            }
        }
        return result
    }

    getTileId(x,y) {
        return TIC.mget(Utils.mapX()+x,Utils.mapY()+y)
    }

    update(){
        _time=_time+1
        _conveyorBelts.each {|conveyorBeltColumn|
            conveyorBeltColumn.each {|conveyorBelt|
                if(conveyorBelt!=null) conveyorBelt.update()
            }
        }
        _gates.each {|col|
            col.each {|gate|
                if(gate!=null) gate.update()
            }
        }

        if(!_started){
            return
        }

        _factories.each {|factory|
            factory.update()
        }

        var jobMoved=false
        _jobs.each { |job|
            job.update()
            job.blocked=!hasNoJobAt(job.x+job.dx,job.y+job.dy)
        }

        _jobs.each { |job|
            if(job.canMove){
                // Check again for blocked - we can move during this loop and change blocked state
                job.blocked=!hasNoJobAt(job.x+job.dx,job.y+job.dy)
                if(!job.blocked){
                    job.move()
                }
                var x = job.x
                var y = job.y
                var tileId=TIC.mget(Utils.mapX()+x,Utils.mapY()+y)
                if(tileId==IN_TILE){
                    job.moveRight()
                    job.ticks=MOVE_TICKS
                }else if(tileId==OUT_TILE){
                    _jobs.remove(job)
                    if (job.isComplete){
                        TIC.sfx(SFXCOMPLETE)
                        _jobsDone=_jobsDone+1
                        _flyingjobs.add(FlyingJob.new(x*16,y*16))
                    }else{
                        TIC.sfx(SFXINCOMPLETE)
                         _killStateFunction.call()
                    }
                    return
                }else if(tileId==CONV_R){
                    job.moveRight()
                    job.ticks=MOVE_TICKS
                }else if(tileId==CONV_L){
                    job.moveLeft()
                    job.ticks=MOVE_TICKS
                }else if(tileId==CONV_U){
                    job.moveUp()
                    job.ticks=MOVE_TICKS
                }else if(tileId==CONV_D){
                    job.moveDown()
                    job.ticks=MOVE_TICKS
                }else if(tileId==DISK||tileId==APPLE||tileId==GLASS||tileId==WIN||tileId==LINUX||tileId==HAMMER){
                    if(job.containsTask(tileId)){
                        job.doTask(tileId)
                        job.ticks=MOVE_TICKS
                        TIC.sfx(SFXDOTASK)
                    }else{
                        job.ticks=MOVE_TICKS
                        job.moving=true
                    }
                }else if(_gates[x][y]!=null){
                    var gate=_gates[x][y]
                    job.ticks=MOVE_TICKS
                    if(gate.passes(job)){
                        job.moveDir(gate.dir)
                    }else{
                        job.moveDir(gate.falseDir)
                    }
                }

                jobMoved=true

                if (tileId==0) {
                    TIC.sfx(SFXINCOMPLETE)
                    _killStateFunction.call()
                }
            }
        }

        var job=_inTile.update()
        if(job!=null){
            job.spawn(_inTile)
            _jobs.add(job)
        }

        if(jobMoved || job!=null) {
            _jobs.sort {|a,b| (a.y==b.y && a.x<b.x) || a.y<b.y }
        }

        _flyingjobs.each{|fj|
            fj.update()
            if(fj.isComplete){
                _flyingjobs.remove(fj)
            }
        }

        _outTile.update()
    }

    draw() {
        _inTile.draw()
        _outTile.draw()

        _conveyorBelts.each {|conveyorBeltColumn|
            conveyorBeltColumn.each {|conveyorBelt|
                if(conveyorBelt!=null) conveyorBelt.draw()
            }
        }
        _gates.each {|col|
            col.each {|gate|
                if(gate!=null) gate.draw()
            }
        }
        _factories.each {|factory|
            factory.draw()
        }

         _jobs.each {|job|
            job.draw()
        }

         _flyingjobs.each{|fj|
            fj.draw()
        }
    }
}

class Game is TIC{

	construct new(){
        var splashState = SplashState.new()
        var titleState = TitleState.new()
        var starState = StarState.new()
        var helpState = HelpState.new()
        var mainState = MainState.new()
        var winState = WinState.new()
        splashState.nextstate = titleState
        titleState.nextstate = helpState
        titleState.idlestate = starState
        starState.nextstate = titleState
        helpState.nextstate = mainState
        mainState.winstate = winState
        mainState.titlestate = titleState
        winState.nextstate = mainState
        winState.starstate = starState
        _state=splashState
        _state.reset()

        // Load map reset data
        for(level in 0..LEVEL_MAP.count-1){
            var leveldata=[]
            var xstart=(level%8)*MAP_W
            var ystart=(level/8).floor*MAP_H
            for(y in 0..MAP_H/2){
                for(x in 0..MAP_W/2) {
                    var tileId=TIC.mget(xstart+x,ystart+y)
                    leveldata.add(tileId)
                }
            }
            MAPRESETS.add(leveldata)
            // Load available belts/gates to place
            var availablegates={}
            for(y in 0..MAP_H-1){
                for(x in 0..MAP_W-1){
                    var xstart=(level%8)*MAP_W
                    var ystart=(level/8).floor*MAP_H
                    var tileId=TIC.mget(xstart+x,ystart+y)
                    if(tileId==CONV_R||tileId==DISK_GATE||tileId==APPLE_GATE||tileId==GLASS_GATE||tileId==WIN_GATE||tileId==LINUX_GATE||tileId==HAMMER_GATE){
                        if(availablegates[tileId]==null){
                            availablegates[tileId]=0
                        }
                        if(y==0){
                            availablegates[tileId]=availablegates[tileId]+1
                        }
                    }
                }
            }
            AVAILABLEGATES.add(availablegates)
        }
	}
	
	TIC(){
        TIC.cls(COLOR_BG)

        _state.update()
        _state.draw()
        _state=_state.next()
	}
}

class FlyingJob is GameObject {
    construct new(x,y) {
        super(x,y,Rect.new(0,0,16,16))
        _ticks=60
    }
    isComplete{_ticks==0}
    update(){
        super.update()
        if(_ticks>0){
            _ticks=_ticks-1
        }
    }
    draw() {
        var frame=(_ticks/5).floor%4
        var d=1-_ticks/60
        TIC.spr(357+frame*2,x,y-(d*d)*32,COLOR_KEY,1,0,0,2,2)
    }
}

class Job is GameObject {
    construct new(x,y,dx,dy,tasks) {
        super(x,y,Rect.new(0,0,16,16))
        _dx=dx
        _dy=dy
        _tasks=tasks
        _ticks=0
        _moving=true
        _blocked=false
        _spawning=false
    }
    dx{_dx}
    dy{_dy}

    canMove { _ticks==0 }
    ticks=(value){_ticks=value}
    isComplete{_tasks.count==0}
    blocked{_blocked}
    blocked=(value){_blocked=value}
    moving=(value){_moving=value}

    draw() {
        var d=(_moving&&!_blocked)?1-_ticks*1.0/MOVE_TICKS:0
        var drawx=(x+_dx*d*d)*16
        var drawy=(y+_dy*d*d)*16
        var s=_spawning&&d<0.5?Utils.easeOutBack(d*2).pow(2):1
        Utils.aspr(352,drawx-4+8,drawy-4+24,COLOR_KEY,s,s,0,0,3,3,8,24,0,0,0,0)
        if(isComplete){
            TIC.spr(355,drawx,drawy,0,1,0,0,2,2)
        }
        for (task in _tasks) {
            Utils.aspr(task.key,drawx+4,drawy+4,COLOR_KEY,s,s,0,0,1,1,4,4,0,0,0,0)
            if(task.value>1) {
                TIC.print("x%(task.value)",drawx+9,drawy+2,0,false,1,true)
            }
            drawy=drawy+8
        }
    }

    update() {
        if(_ticks>0){
            _ticks=_ticks-1
        }
    }

    spawn(intile){
        x=intile.x/16
        y=intile.y/16
        TIC.sfx(SFXSPAWN)
        _spawning=true
    }

    // Actually move this job
    move(){
        if(_moving&&!_blocked){
            x=x+_dx
            y=y+_dy
            _spawning=false
        }
    }

    // Set the direction of the next move
    moveRight() {
        _dx = 1
        _dy = 0
    }
    moveLeft() {
        _dx = -1
        _dy = 0
    }
    moveDown() {
        _dx = 0
        _dy = 1
    }
    moveUp() {
        _dx = 0
        _dy = -1
    }
    moveDir(dir){
        if(dir==UP){
            moveUp()
        }else if(dir==RIGHT){
            moveRight()
        }else if(dir==DOWN){
            moveDown()
        }else{
            moveLeft()
        }
    }

    doTask(task){
        if (_tasks[task] > 0) {
            _tasks[task]=_tasks[task]-1
            if(_tasks[task]==0){
                _tasks.remove(task)
            }
        }
    }

    containsTask(task){
        return _tasks[task] && _tasks[task] > 0
    }
}

// <TILES>
// 000:5555555555555555555555555555555555555555555555555555555555555555
// 001:1099999903099999033099990333099903333099032209990012099999901999
// 002:9101999990309999903000990032330902333320023333209033330999000099
// 003:9900099990233099020233090320230903320209903320999900099999999999
// 004:9330399932000399203039990393993939939309993030299300023999303399
// 005:9933329993000039313200399399333993339999930023199300003999233399
// 006:9993023993993023303993030003300030399303320399399320399999999999
// 007:9999939993333139200393033003920330293003303930029319333999999999
// 016:00000000000000000f0f00f00f0ff0f00f0f0ff00f0f00f00f0f00f000000000
// 017:0000000000000000090809999098089090980890909808900908889000000000
// 018:9999999999900999900030999033330990333309900030999990099999999999
// 019:9999999999900999990300099033330990333309990300099990099999999999
// 020:9999999999900999990330999033330990033009990330999900009999999999
// 021:9999999999000099990330999003300990333309990330999990099999999999
// 022:9992299999211299921111292331110913331099913309999900000999999999
// 032:9000009905225509052255090555550905333509053335099000009999999999
// 033:9990809990080099088088090ffff0990dddd099077777090aaaaa0990505099
// 034:9000099901221099023e209902ee209901221f099000cdf099990c0999999099
// 048:990000999007800900778809907ef80900eeff0990e00f090009900999999999
// 049:900000990000000903303309031013090fffff0903ddd3090333330999999999
// 050:99999999990099999020999902100000011cccc0901000000111099990009999
// 064:900e009900eee009050005090555550905333509053000099007770999907099
// 065:990e009990eee099080008090ffff0990dddd099077000090a07770990507099
// 066:900e099900eee0990200009902ee209901221f09900000f09907770999907099
// 067:990e009990eee00900000809907ef80900eeff0990e000090007770999907099
// 068:900e009900eee00903000309031013090fffff0903d000090307770999907099
// 069:990e099990eee0999000099902100000011cccc0901000000107770990007099
// 080:9000009900225509070250e0770550ee070330e0003335099000009999999999
// 081:999080999008009900808809070ff0e0770dd0ee070770e000aaaa0990505099
// 082:9000099901221099003e2009070e20e0770210ee0700c0e090990c0999999099
// 083:990000999007800900778809070ef0e0770ef0ee070000e00009900999999999
// 084:900000990000000900303309070010e0770ff0ee070dd0e00033330999999999
// 085:999999999900999990209909071000e0771cc0ee971000e00111090990009999
// 096:900700990077700905000509055555090533350905300009900eee099990e099
// 097:9907009990777099080008090ffff0990dddd099077000090a0eee099050e099
// 098:90070999007770990200009902ee209901221f09900000f0990eee099990e099
// 099:990700999077700900000809907ef80900eeff0990e00009000eee099990e099
// 100:900700990077700903000309031013090fffff0903d00009030eee099990e099
// 101:99070999907770999000099902100000011cccc090100000010eee099000e099
// 112:90000099002255090e025070ee0550770e033070003335099000009999999999
// 113:9990809990080099008088090e0ff070ee0dd0770e07707000aaaa0990505099
// 114:9000099901221099003e20090e0e2070ee0210770e00c07090990c0999999099
// 115:9900009990078009007788090e0ef070ee0ef0770e0000700009900999999999
// 116:9000009900000009003033090e001070ee0ff0770e0dd0700033330999999999
// 117:9999999999009999902099090e000070ee0cc0770e0000700011090990009999
// 128:0212222002222222902222219902222299022222902222220211222202122220
// 129:0212222022222220122222092222209922222099222222092222212002222220
// 130:9900009990222209021122200212222002222220022222200222222002122220
// 131:9900000090222222021122210212222202222222022222229022222299000000
// 132:0000000022222222111111112222222222222222222222222222222200000000
// 133:0000009922222209122222202222222022222220222222202222220900000099
// 134:0212222002122222021222210212222202122222021222220212222202122220
// 135:0212222022122220112222202222222022222220222222202222222002122220
// 144:9999900099900222990222219021122290212222022222220222222202122220
// 145:0009999922200999122220992222220922222209222222202222222002222220
// 146:0212222002122220021222200212222002122220021222200212222002122220
// 147:0099990022099022122002112222221222222222222222222222222202122220
// 148:9900009990222209021122200212222002222220022222209022220999000099
// 149:0000000022222222111111112222222222222222222222222222222202122220
// 150:0000000002222222021122210212222202222222022222220222222202122220
// 151:0000000022222220111122202222222022222220222222202222222002122220
// 160:0212222002222222022222219022222290222222990222229990022299999000
// 161:0212222022222220122222202222220922222209222220992220099900099999
// 162:0212222002222220022222200222222002222220022222209022220999000099
// 163:0212222022122222112222212222222222222222222002222209902200999900
// 164:9999999999999999999999999999999999999999999999999999999999999999
// 165:0212222022122222112222212222222222222222222222222222222200000000
// 166:0212222002122222021222210212222202222222022222220222222200000000
// 167:0212222022222220121222202222222022222220222222202222222000000000
// 204:999999999999999999999999999909999990b0999990bbb099990abb999990ab
// 205:99999999999999999999999999999999999999999999999909999999b0900000
// 206:9999999d990090d0990a0dc09990dfc0990dfc0999dfdc090dffc099dfdcc099
// 207:0999999999999999999999999999999999999999999999999999999999999999
// 220:9999990a000999907770090b677660bb76600bbb760bbbbb60bbbbbb0bbbbbbb
// 221:b00bbbbb0bbbbbbbbbbbb000bbbb0333bbb03333bb030033bb030033bb023333
// 222:0ffc0999bfcc09990aa000092002333032033333320333003203330020023333
// 223:9999999999999999999999999999999909999999309999993099999920999999
// 236:0bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0bbbbbb0bbbbbbb0bbbbbbb0bbbbbbb0b
// 237:bb002332bbb00000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
// 238:0bb02332bbbb0000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0bbbbb
// 239:0b099999bb099999bbb09999bbbb0999bbbbb099bbb00009b00bbbb0aabbbb00
// 252:bbbbbb0bbbbbbb0abbbbbbb0bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbabbbbbaaa
// 253:bbbbbbabbbbbbabbaaaa0abb00000aabbba0900abaa09990aa099999a0999999
// 254:bbb0bbbbbbb000bbbbb0330bbbb03330bbbb0000aabbbbba00aabbbb99000000
// 255:ab00bb00bb00bbb0bbbbbaa00000000933303309000a0099bbbaa09900000999
// </TILES>

// <SPRITES>
// 000:9994444499455555945599994559944445994555459455994594599445945945
// 001:4444499955555499999955494449955455549954995549544995495454954954
// 002:9944444494559999455994444599455549945599494559944945994549459455
// 003:4444449999995549444995545554995499554994499554945499549455495494
// 004:4449999945994444499455559945599994559944945994559459455994594599
// 005:9999944444449954555549949995549944995549554995499554954999549549
// 006:9900000090333333033333330222222202011111021eeeee021eeeee021eeeee
// 007:0000000033333310333331102222221011111210eeee3210eeee3210eeee3210
// 008:9999999999999999999999009999903399999036999903669999036699903663
// 009:9999999999999999009999993309999963099999663099996630999936630999
// 010:999999999999009999990e0999990ee099990ee099990e099999009999999999
// 011:999999999999999999999999999999999000000990eeee09990ee09999900999
// 012:222222222222222222222222222222222222222c222222cf222222cf2222222c
// 013:222cc22222cffc222cfffc22cfffffc2ffffffc2fffffdfcffffffdcfffffdfc
// 014:22222222222222222222c222222cc22222ccc2222cdc2222cdc22222ddc22222
// 015:2222222222222222222222222222222222222222222222222222222222222222
// 016:4594594545945994459455994599455545599444945599999945555599944444
// 017:5495495449954954995549545554995444499554999955495555549944444999
// 018:4945945549459945494559944994559945994555455994449455999999444444
// 019:5549549454995494499554949955499455549954444995549999554944444499
// 020:9459459994594559945994559455994499455999499455554599444444499999
// 021:9954954995549549554995494499554999955499555549944444995499999444
// 022:021eeeee021eeeee021eeeee021eeeee021eeeee021333330222222200000000
// 023:eeee3210eeee3210eeee3210eeee3210eeee3210333332102222220900000099
// 024:9990366399036633990366669903366699903333999900009999999999999999
// 025:3663099933663099666630996663309933330999000099999999999999999999
// 026:99900999990ee09990eeee099000000999999999999999999999999999999999
// 027:999999999900999990e099990ee099990ee0999990e099999900999999999999
// 028:2222222c22222221222221552221555521555555555555442155542222554222
// 029:ffffdfdccffdfdcdcfffdfcdccfdfcdd5cffdcdc12cdcdc222cfcc22222cc222
// 030:dc222221dc522225c5551255c555445544455555211455554555555544444444
// 031:5222222242222222422222224999222242229222499229224229229249929292
// 032:9000000001111111000000000000000000000000000000000000000000000000
// 033:0000000911111110000000000000000000000000000000000000000000000000
// 034:1112222200011122222000112222220011122222000111222220001122222200
// 035:0002222211100022222111002222221100022222111000222221110022222211
// 044:2254222222222222222222222222222222222222222222222222222222222222
// 045:2222222222222222222222222222222222222222222222222222222222222222
// 046:2229292922292898222892892222892822222899222222222222222222222222
// 047:9992929288898292999829828882982299998222222222222222222222222222
// 048:0000000000000000000000000000000000000000000000000111111190000000
// 049:0000000000000000000000000000000000000000000000001111111000000009
// 064:9000000000000000100000001000000010000000100000001000000010000000
// 065:0000000900000000000000010000000100000001000000010000000100000001
// 066:9000000000000000100000001000000010000000100000001000000010000000
// 067:0000000900000000000000010000000100000001000000010000000100000001
// 072:99d99ddd9dff99df99dff99dd99dff99df99dff9df99dff9d99dff9999dff99d
// 073:99ddd999f99dff99ff99dff9dff99dfd9dff99dd9dff99dddff99dfdff99dff9
// 074:99ddd99d999dff99df99dff9dff99dff9dff99df9dff99dfdff99dffdf99dff9
// 075:dd99dd99dff99dd99dff99dd99dff99df99dff99f99dff9999dff99d9dff99dd
// 076:9999dff99df99dff9dff99df99dff99d999dff99999dff9999dff99d9dff99df
// 077:9dff999999dff999f99dff99ff99dff9dff99dfddff99dfdff99dff9f99dff99
// 080:1000000010000000100000001000000002622222067622220262222290000000
// 081:0000000100000001000000010000000122226260222227202222626000000009
// 082:1000000010000000100000001000000006262222027222220626222290000000
// 083:0000000100000001000000010000000122222620222267602222262000000009
// 088:9dff99dfdff99dffdf99dff91ddddddd01111111022222280222222290000000
// 089:f99dff9999dff99d9dff99ddddddddd111111110822222202222222000000009
// 090:999dff9999dff99d9dff99df1ddddddd01111111022222280222222290000000
// 091:dff99dfdff99dff9f99dff99ddddddd111111110822222202222222000000009
// 092:dff99dffdf99dff9d99dff991ddddddd01111111022222210222222290000000
// 093:99dff99d9dff99dddff99dfdddddddd111111110122222202222222000000009
// 096:9999999999999999999ccccc99cfffff99cfffff99cfffff99cfffff99cfffff
// 097:9999999999999999ccc99999fffc9999ffffccccf3333333ffffffffffffffff
// 098:99999999999999999999999999999999ccccc999fffffc99fffff099fffff099
// 100:0000000000000000000000000000000000009000000980000098000009800000
// 101:9cccccc9cffffffccfffffffcfffffffcfffffffcfffffffcfdfdfdfcdfdfdfd
// 102:9999999999999999ccccccc9fffffffcfffffff0fffffff0dfdfdfd0fdfdfdc0
// 103:99999cc99999cffc999cfffc99cfffff9cffffffcffffffdcfffffff9cfffffd
// 104:9999999999999999999999c9c9999cc9c999ccc9fc9cdc99dccdc999fcddc999
// 105:999999999c999999cfc99999cffc9999cfffc999cffffc99cfffffc9cffffffc
// 106:9999999999999999999999cc99999cfc9999cffc999cfffc99cdfffcccdffffc
// 107:99999999cc999999ccc999999cdc999c9cddc99c99cddccf999cddcd999cddcf
// 108:99999999cc999999cfc99999fffc9999ffffc999dffffc99ffffffc9dfffffc9
// 112:99cfffff99cfffff99cfffff99cfffff99cfffff99cfffff99cfffff99cfffff
// 113:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
// 114:fffff099fffff099fffff099fffff099fffff099fffff099fffff099fffff099
// 115:0009900000009909000009990000009800000088000000000000000000000000
// 116:9800000080000000800000000000000000000000000000000000000000000000
// 117:cccccccccdddddddcdddddddcdddddddcdddddddcdddddfdcddddfdf90000000
// 118:ccccccc0ddddddd0ddddddd0ddddddd0dddfdfd0fdfdfdf0dfdfdff000000009
// 119:9cffffdf99cffdfd99cfffdf999cfdfc999cffdc9999cdcd9999cfcc99999cc9
// 120:dcdc9999cddc9999cdc99999ddc99999dc999999c99999999999999999999999
// 121:cfffffdfcffffdfd9cffdfdf99cffdfd999cffdf9999cdfd99999ccf9999999c
// 122:cdfdfffccfdfffcccdfdfc99cfdfc999cdfc9999cfc99999cc999999c9999999
// 123:9999cdcd9999cddc99999cdc99999cdd999999cd9999999c9999999999999999
// 124:fdffffc9dfdffc99fdfffc99cfdfcc99cdffc999dcdc9999ccfc99999cc99999
// 128:99cfffff99cfffff99cfffff990dfdfd99cfdfdf990dfdfd9990000099994444
// 129:fffffffffdfdfdfddfdfdfdffdfdfdfddfdfdfdffdfdfdfd0000000044444444
// 130:fffff099fdfdf099dfdfd099fdfdf099dfdfd099fdfdf0990000049944444499
// 135:9999999999999999999999999999cc99999cfdc999cfffdc9cfffffd9cffffff
// 136:999999999999999999999999999999c999999cc99999cdc9cccccdc9fcfffdc9
// 137:9999992999999229999923329992333299233333923333339233333399233333
// 138:9999999999999999999999999999999929999999219999992199999929999999
// 139:9999999999999999999999229999923399992333999933339992333399922333
// 140:9999999999999999999999992299999933299999333299993333299933332999
// 141:9999999999999992999999239999923399999233999923239999232399992332
// 142:9999999999999999299999993299999932999999332999993329999933329999
// 144:9900000000000000000000000000000000000000000000000000000000000000
// 151:cfffffffcfffffffcffffffd9cfffffc9cffffdc99cfffcf999cfdcf9999cccc
// 152:dcffdcc9cffddcc9cffdcc99ffddcc99ffdcc999fdcc9999dcc99999cc999999
// 153:9923333299923332999233219999232999992219999992999999999999999999
// 154:1999999999999999999999999999999999999999999999999999999999999999
// 155:9992313399921333999933339999233399999232999999219999999999999999
// 156:3332199933219999321999992199999919999999999999999999999999999999
// 157:9999233399992332999923219999921399999923999999929999999999999999
// 158:2332999913219999332999993219999921999999199999999999999999999999
// 167:9999999999999999999999999999999999999999999c999999cdc9999cdfdcc9
// 168:9999999999999999999999999999999999999999999999999999999c999999cc
// 169:9999999999999929999992329999923399999223999992329999923399999233
// 170:9999999999999999999999992999999932999999329999992299999932299999
// 171:9999999999999999999999229999923399999233999992339999233399992333
// 172:9999999999999999999999992999999932999999329999993329999933299999
// 173:9999999999999999999999229999992399999233999923339999233399923333
// 174:9999999999999999999999992999999932999999329999993329999933299999
// 183:9cfdfffccffffffdcfffffdfcffffdfc9cffffdc9cfffdcd99ccffcf9999cccc
// 184:ccccccfccddffffccdfffffcdfffffdcfffffdc9ffffdc99ffddc999ccc99999
// 185:9999923399999233999992339999923399999922999999999999999999999999
// 186:3322999933219999321999992199999919999999999999999999999999999999
// 187:9999233399992333999992339999923399999923999999229999999199999999
// 188:3329999933299999321999993299999921999999199999999999999999999999
// 189:9923333399222333999992339999992299999232999922119999999999999999
// 190:3329999933299999332999993219999921999999999999999999999999999999
// 199:999999999999999999999999999999999999999999999999999cccc999cffffc
// 200:999999999999999999999999999999999999999999999999999ccc99cccfffc9
// 201:9999999999999999999999929999992399999233999923339999233399923333
// 202:9999999999999999999999992999999932999999329999993329999933299999
// 203:9999999999999999999999229999923399992333999233339923333399233333
// 204:9999999999999999999999992999999932999999329999993229999923299999
// 215:9cffffff9dfffffdcffffffdcffffffccdcfffdcc99cfdcd9999cdcd99999ccc
// 216:cfdffffccddffffccdfffffcddffffdcdfccffc9fc99cdc9c9999c9999999999
// 217:9923333399223332999923329999923199999233999923329999922199999999
// 218:2232999933329999333299992321999922199999219999999999999999999999
// 219:9923333299923332999233319999233399992333999922229999911999999999
// 220:3329999933299999232999991219999921999999199999999999999999999999
// 231:99999999999999999999999999999ccc9999cdff999cdfff99cdffff9cdffffd
// 232:99999999999999999999999999999999c999ccc9ccccffdcdccdfffcdcddffdc
// 238:3339999939999999399999999999999999999999999999999999999999999999
// 239:9999933399999993999999939999999999999999999999999999999999999999
// 247:cdffffdfcffffffdccffffdd99cffdfc999cffdc9999cfcd9999cdcc99999cc9
// 248:dcdfffc9cddfffc9cdfccd99ddc99c99dc999999c99999999999999999999999
// 254:9999999999999999999999999999999999999999399999993999999933399999
// 255:9999999999999999999999999999999999999999999999939999999399999333
// </SPRITES>

// <MAP>
// 000:212121000000000000000000000000000000000000000000000000000000210000000000000000000000000000000000000000000000000000000000212121000000000000000000000000000000000000000000000000000000212100000000000000000000000000000000000000000000000000000000212100000000000000000000000000000000000000000000000000000000212121550000000000000000000000000000000000000000000000000000212121210500000000000000000000000000000000000000000000000000150521000000000000000000000000000000000000000000000000000000
// 002:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002103000000000000000000000000000000000000000000000000000000000011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000051000000000000000000000000000000000000000000000000
// 003:000000000000000000000000000000000000000000000000000000000000000000012121122100000000000000000000000000000000000000000000000000010000120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000021225100000000000000000000000000000000000000000000000000000041020031000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000
// 004:000000012121020011000000000000000000000000000000000000000000000000000000005100000000000000000000000000000000000000000000000000000000001351000000000000000000000000000000000000000000000000000041220000000000000000000000000000000000000000000000000000012105002111000000000000000000000000000000000000000000000000012105002211000000000000000000000000000000000000000000000000000001212200000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000
// 005:000000000000000000000000000000000000000000000000000000000000000000000000001100000000000000000000000000000000000000000000000000000000000011000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000021024100000000000000000000000000000000000000000000000000000031000031000000000000000000000000000000000000000000000000000000000011000000000000000000000000000000000000000000000000001200110000000000000000000000000000000000000000000000
// 006:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000410031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000312341000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 015:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000300001200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 016:020202020000000000000000000000000000000000000000000000000000121212120000000000000000000000000000000000000000000000000000031213031300000000000000000000000000000000000000000000000000222222000000000000000000000000000000000000000000000000000000020222220000000000000000000000000000000000000000000000000000020222230223220000000000000000000000000000000000000000000000220222000000000000000000000000000000000000000000000000000000021200000000000000000000000000000000000000000000000000000000
// 017:212121212121550000000000000000000000000000000000000000000000212100000000000000000000000000000000000000000000000000000000212121250000000000000000000000000000000000000000000000000000212100000000000000000000000000000000000000000000000000000000551545350500000000000000000000000000000000000000000000000000055545000000000000000000000000000000000000000000000000000000210000000000000000000000000000000000000000000000000000000000211500000000000000000000000000000000000000000000000000000000
// 018:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000122100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 019:000000000000000000000000000000000000000000000000000000000000000000000121510000000000000000000000000000000000000000000000000000000000110000000000000000000000000000000000000000000000000000000121510000000000000000000000000000000000000000000000000000000023000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000051455100000000000000000000000000000000000000000000000000000000002151000000000000000000000000000000000000000000000000
// 020:000000000000000012000000000000000000000000000000000000000000000000000023110000000000000000000000000000000000000000000000000000000000030000000000000000000000000000000000000000000000000000000023110000000000000000000000000000000000000000000000000000010221130023110000000000000000000000000000000000000000000000012300001100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012000000000000000000000000000000000000000000000000
// 021:000000000000002311220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000023002200000000000000000000000000000000000000000000000000000002001200000000000000000000000000000000000000000000000013002311000000000000000000000000000000000000000000000000000000010000110000000000000000000000000000000000000000000000
// 022:000000000121000013000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000021030000000000000000000000000000000000000000000000000000000000130000000000000000000000000000000000000000000000000000002141000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000
// 023:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000021410000000000000000000000000000000000000000000000
// 031:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 032:231322120000000000000000000000000000000000000000000000000000000023000000000000000000000000000000000000000000000000000000000003220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000021302021300000000000000000000000000000000000000000000000000000000001300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000120000120000000000000000000000000000000000000000000000000000
// 033:132212230000000000000000000000000000000000000000000000000000232323000000000000000000000000000000000000000000000000000000220303220000000000000000000000000000000000000000000000000000232323000000000000000000000000000000000000000000000000000000230302121300000000000000000000000000000000000000000000000000021323121200000000000000000000000000000000000000000000000000132323130000000000000000000000000000000000000000000000000000120303030000000000000000000000000000000000000000000000000000
// 034:210000000000000000000000000000000000000000000000000000000000212135000000000000000000000000000000000000000000000000000000212121350000000000000000000000000000000000000000000000000000212121000000000000000000000000000000000000000000000000000000212155212121210000000000000000000000000000000000000000000000051521212121453521252121000000000000000000000000000000000000051555352121212121000000000000000000000000000000000000000000051525354555212121210000000000000000000000000000000000000000
// 035:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000021125100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000102020202000202020002000000000000000000000000000000000000
// 036:000000000000000000000000000000000000000000000000000000000000000000000121030000000000000000000000000000000000000000000000000000002113030000000000000000000000000000000000000000000000000000000115002200000000000000000000000000000000000000000000000000000121512300000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000120000000000000000000000000000000000000000000000000200020202020222020002020000000000000000000000000000000000
// 037:000000002113210000000000000000000000000000000000000000000000000000000000000011000000000000000000000000000000000000000000000000011500110000000000000000000000000000000000000000000000000000000021132500000000000000000000000000000000000000000000000000000000230011000000000000000000000000000000000000000000000000031200000000000000000000000000000000000000000000000000000000000001000023001100000000000000000000000000000000000000000012020202230202020202020000000000000000000000000000000000
// 038:000001450000001100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002112030000000000000000000000000000000000000000000000000000000000001100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000021300000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000002020202020202020302000000000000000000000000000000000000
// 039:000000212103234100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000222300000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000020202000202020002020000000000000000000000000000000000
// 040:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000013020202020202020202110000000000000000000000000000000000
// 046:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000023000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 047:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002323000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 048:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000232323000000000000000000000000000000000000000000000000222300001300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 049:000000030000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000003120000000000000000000000000000000000000000000000000000000000220000000000000000000000000000000000000000000000000000000023232323000000000000000000000000000000000000000000000000031302121300000000000000000000000000000000000000000000000000021200000203000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 050:130313231300000000000000000000000000000000000000000000000000030303000000000000000000000000000000000000000000000000000000121213120000000000000000000000000000000000000000000000000000121322220000000000000000000000000000000000000000000000000000232323232323000000000000000000000000000000000000000000000000021202122300000000000000000000000000000000000000000000000000032303230203230000000000000000000000000000000000000000000000021203221323000000000000000000000000000000000000000000000000
// </MAP>

// <WAVES>
// 000:01358acefeca853101368acefeca8531
// 001:001235789aabcdeffffeda9876332110
// 002:0123456789abcdea0123456789abcd53
// 003:0123456789abcdef0123456789abcdef
// 005:0123456789abcdedecab997654421100
// 006:14444689abcedffddccba98779665433
// 007:0000000000000789abffffffffffffff
// 008:000000000000000047afffffffffffff
// 009:000000000001231369bdebdeffffffff
// 010:000000000000567899abbfffffffffff
// 011:0000124579bcdefff8ddca8754332111
// </WAVES>

// <SFX>
// 000:02000200020002001200320042004200520052007200720092009200a200a200c200d200e200e200f200e200e200e200e200e200e200e200e200e200470000000000
// 001:08f83800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800680000000000
// 002:00c0007000500000310051008100c100d100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100c57000000000
// 003:02004200420062007200820092009200a200b200b200c200c200d200e200e200e200e200f200f200f200f200f200f200f200f200f200f200f200f200507000000000
// 004:088008500800f800f800f800080008000800080008000800080018001800280038004800480058006800780088009800a800b800c800d800e800f800580000000300
// 005:080008400850087008c0080018002800380048004800580058006800780078008800880098009800a800a800b800c800c800e800e800e800e800f800309000000500
// 006:8b006b404b702b000b400b700b000b400b700b400b700bb00b400b700bb00b701bb02be02b704bb05be07b708bb08be09b709bb0abe0cb70ebb0fbe0460000000000
// 048:04002100410f610f910ee10ef10df10df10df10df10df10df10df10df10df10df10df10df10df10df10df10df10df10df10df10df10df10df10df10da02000000000
// 049:64008400b400e400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400604000000000
// 050:71009100a100b100c100c100c100c100c100d100d100d100d100d100d100d100d100d100d100d100d100d100d100d100d100d100d100d100d100e100520000000000
// 052:060046006600760086009600a600a600a600a600a600b600b600b600b600b600b600b600c600c600c600c600c600c600d600d600d600d600d600e600450000000000
// 053:04001100210021003100410041005100610061007100810081009100a100b100b100c100c100d100d100c100c100c100c100c100c100c100c100c100200000000000
// 054:04f7110021003100410051006100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100a00000000000
// 055:f700f700f700f700f700f700f700f700370007000701270237016700970fc70ef70ff700f700f700f700f700f700f700f700f700f700f700f700f700400000f10098
// 056:f700f700f700f70037000700070047007700a700b701b702b701c700c70fc70ef70ff700f700f700f700f700f700f700f700f700f700f700f700f700400000f10098
// 057:27005700670077008700870087009700a700a700b700b700b700b700b700c700d700d700e700f700f700f700f700f700f700f700f700f700f700f700400000000000
// 058:d800b800a800880078006800680068006800680068006800680068006800680068006800680068006800680068006800680068006800680068006800400000000000
// 059:720032000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200200000000000
// 060:37000700070037005700770087009700a700a700b701b702b701c700c70fc70ef70ff700f700f700f700f700f700f700f700f700f700f700f700f700400000f10098
// 061:01001100210021003100410041005100610061007100810081009100a100b100b100c100c100d100d100c100c100c100c100c100c100c100c100c100200000000000
// 062:0100110021003100410051006100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100200000000000
// 063:f700f700270007002700570077009700a700a700b701b702b701c700c70fc70ef70ff700f700f700f700f700f700f700f700f700f700f700f700f700400000f10098
// </SFX>

// <PATTERNS>
// 000:900895100000000000000000400895100000000000000000800895100000000000000000400895100000000000000000900895100000000000000000000000900893000000000000022600000000000000000000000000000000000000000000100000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 001:4969a90000000000000000000000000000000000000000000a79a10000000000000741000000000000000521000000000008a10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004f89a90000000000000000000d61000000000a51000000000941000000000631000000000008a1000000000000000000
// 002:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004339b50551000771000991000aa1000cc1000ee1000ff100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 003:0008a10000000000000000000000000000000000000000006ff9a90000000000000000000000000dd1000cc1000aa1000999a10000000881000000000000000771000000000661000000000000000551000000000000000441000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006ff9a90000000000000000000000000dd1000000000aa1000000000661000000008999a9000000000000000000
// 004:0008a10000000000000000000000000000000000000000000008a1000000000000000000000000000000000000000000baf9a700000000000000000009d10000000000000007a100000000000000069100000000000000058100000000000000047100000000036100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b9f9a90008a100000000000007d10000000006a100000000058100000000035100000000000000000000
// 005:9f89a50000000000000000000d71000000000b61000000000a51000000000941000000000731000000000000000000009f89a90000000d71000000000a61000000000941000000000631000000000000000000000000000000000000000000000008a10008a1000000000000bf89a70000000d71000000000b6100000000095100000000074100000000063100000000000000000000000000000000000000000000052100000000042100001000031100000000021100000000010100000000
// 006:9008b30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004008b50000000000000000000000000000000000000000000000000000000000000000000000000000000aa100099100087100076100055100000000044100033100022100000000
// 007:4ff9a70000000000000000000dd1000000000bb1000000000991000000000771000000000661000000000551000000000000000000000000000000000000000000000000000000008ff9a90000000aa1006ff9a90000000000000000000dd1000000000cc1000000000aa100000000099100000000088100000000066100000000055100000000000000000000000000000000000000000000000000000000000000000000000000044100000000033100000000022100000000011100000000
// 008:d8f9a700000000000000000007d10000000006b10000000005910000000004710000000003510000000000000000000000000000000000000000000000000000000000000000000000000048f9a900000000000000000000000007d1000000008ff9a90000000000000000000dd9b10000000bb1000000000aa100000000099100000000088100000000077100000000066100000000055100000000044100000000000000000000000000000000033100000000022100000000011100000000
// 009:4ff9c90000004008c9b008c90008c11008c19008c90000001008c10000000000004008cb000000b008c99008c90000004008c90000004008c9b008c90000001008c19008c90000001008c10000000000004008cb000000f008c90000000000004008c90000004008c9b008c90000001008c19008c90000001008c1000000000000d008c90008c16008c90000000000004008c90000004008c9b008c90000001008c19008c90000001008c10000004008cb0008c1bff9554889cb0000004ff905
// 010:4ff9550000001008c14008d540081d000000000000000000400805000000000000b008e540081db008e5b008e50000004008550000001008c14008d540081d000000000000000000400805000000000000b008e540081db008e5b008e50000004008550000001008c14008d540081d000000000000000000400805000000000000b008e540081db008e5b008e50000004008550000001008c14008d540081d000000000000000000400805000000000000b008e5baf9cb0008e1b00855b589cb
// 011:1ff9c10000000008c1f008c90008c11008c1d008c90000001008c10000000000000008c1f008c90008c10008c10000001008c10000000008c1f008c90000001008c1d008c90000001008c10000000000000008c16008cb0008c1b008c90000001008c10000000008c1f008c90000001008c1d008c90000001008c10000000000000008c1b008c90008c18008c90000001008c10000000008c1f008c90000001008c1d008c90000001008c10000000000006fa9cb000000bff9e56859cb000000
// 012:614949800849f00849b008490000000000000000000000008008a90000000000009008a9b008a90000009008a9000000e0084900000000000000000000000000000040084be22849d00849100000900849000000100000b00849000000000000641949800849f00849b008490000000000000000000000004008a9000000000000000000000000000000f008a74008a9600849000000000000100000600849800849900849000000800849000000600849400849600849400849d00847b00847
// 013:8f89a90000000b61000a51000941000521000411000000000201000000000101000000000000000000000000000000001000000000000000000000008f89a90000000a61000000009008a9000000000000000000b008a90000000084000008a1ef99a90000000d71000004000a6100000000d008a9e008a9bf89a90d71000000000a61000000000851000000000641000000000431000000000211001000000000000000000000004f89a90000000d51000000006ff8a90000000a4100000000
// 014:4008550000001008c14008d540081d000000000000000000400805000000000000b008e540081db008e5b008e50000004008550000001008c14008d540081d0000000000000000004008050000004008d50008d140081d6008d58008d5000000b008550000001008c1b008d540081d000000000000b008d54008050000000000006008e740081d6008e76008e7000000b008550000001008c1b008d540081d000000000000000000400805000000b008d500000040081db008d59008d540081d
// 015:9f8929bf8829de89294d892b9c8929bb8929da892949892b988929b89929d8a92948b92b98c929b8d929d8e92948f92bb8f82940082b68e92bb8d92bb8c92948b92b68a92bb8992bb8892949892b6a892bbb892bbc89294d892b6e892bbf892bbf89294f882b6e892bbd892bbc89294b892b6a892bb9892bb8892948992b68a92bb8b92bb8c92948d92b68e92bb8f92bb8f82940082b68e92bb8d92bb8c92948b92b68a92bb8992b48892b69892b8a892bbb892b4c892dfd892bbe892b8f892b
// 016:7f89a90000000b61000a51000941000521006008a97008a94f89a90d71000000000a61000000000851000000000641000000000431000000000211000008a10000001008d1000000ef99a70000000a61000000009f99a70000000a6100000000bf89a70000000d71000000000a61000000000008a19008a78008a70000000000000000000000000851000000000641000000000431000000000211000000000000000000000000001008d10000000000000000000ff8a1000000000000000000
// 017:c008550000001008c1c008d540081d0000000000000000004008050000000000009008e540081d9008e59008e5000000e008550000001008c1e008d540081d0000000000000000004008050000009008d500000040081d000000b008d50000004008550000001008c14008d540081d0000000000004008d5400805000000000000b008e540081db008e5b008e50000004008550000001008c14008d540081d000000000000000000400805000000b008d51008d140081dd008d5b008d540081d
// 018:4239cb6008cbb008cbb008c94008cb6008cbb008cbb008c94008cb6008cbb008cbb008c94008cb6008cbb008cbb008c94239cb6008cbb008cbb008c94008cb6008cbb008cbb008c94008cb6008cbb008cbb008c94008cb6008cbb008cbb008c94239cb6008cbb008cbb008c94008cb6008cbb008cbb008c94008cb6008cbb008cbb008c94008cb6008cbb008cbb008c94239cb6008cbb008cbb008c94008cb6008cbb008cbb008c94008cb6008cbb008cbb008c94008cb6008cbb008cbb008c9
// 019:8f89a90000000b61000a51000941000521000411000000000201000000000101000000000000000000000000000000001000000000000000000000008f89a90000000a61000000009008a9000000000000000000b008a9000000000000000000ef89a90000000d71000000000a6100000000d008a9e008a9bf89a90d71000000000a61000000000851000000000641000000000431000000000211001000000000000000000000004f89a90000000d51000000006ff8a90000000a4100000000
// 020:414949600849800849d00847000000000000000000000000000000000000400849900849000000800849400849000000d46949000000000000000000b00849000000000000000000800849000000000000000000900849000000000000800849000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bff949000000000000b008490000000000009f0949000000000000d0f94700000040081bbf0947
// 021:b889a7000000066100055100044100022100011100000000011100000000011100000000000000000000000000000000100000000000000000000000b889a70000000661000000004008a90000000000000000006008a90000000000000044009889a90000000771000004000661000000008008a96008a9e889a7077100000000066100000000000000d008a7b449a74008a9033100000000000000e008a7000000000000000000100000000000000000000000000000000000000000000000
// 022:4889a9000000076100055100044100022100000000000000c559a70000000000000661007008a90551000000000441009008a90331000000000111000008a10000001008d1000000b999a70000000661000000006999a70000000661000000008889a70000000771000000000661000000000008a16008a74008a70000000000000000000000000000000000000000000000000431000000000211000000000000000000000000001008d10000000000000000000ff8a1000000000000000000
// 023:4008c9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d008c90000000000000000000000000000000000000000000000000000000000000000000ff1000000000ee1000000000dd1000000000cc1000000000bb1000000000aa100000000099100008000088100000000077100000000066100000000055100000000044100000000033100000000022100000000011100000000000000000000000000000000000000000000
// 024:0000006008c90000000000000000000000000000000000008008c90000000000000000000000000000000000000000000000004008cb0000000000000000000000000000000000000000000000000000000000000ff1000000000ee1000000000dd1000000000cc1000000000bb1000000000aa100000000099100008000088100000000077100000000066100000000055100000000044100000000033100000000022100000000011100000000000000000000000000000000000000000000
// 025:000000000000b008c9000000000000000000000000000000000000b008c90000000000000000000000000000000000000000000000008008cb0000000000000000000000000000000000000000000000000000000ff1000000000ee1000000000dd1000000000cc1000000000bb1000000000aa100000000099100008000088100000000077100000000066100000000055100000000044100000000033100000000022100000000011100000000000000000000000000000000000000000000
// 026:000000000000000000000000000000000000000000000000000000000000f008c90000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009ff9d70000000000001000009dd9d70000000000001000009aa9d70000000000001000009889d70000000000001000009559d7000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 027:f00847400849b00849800849071600000000000000000000000000000000000000000000000600400849600849000000b00849052600000000000000900849000000000000000831400849000000000000000000600e49000000000000000000f00847400849b00849800849000000071600000000000000000000000000000000000000000600400849600849000000b00849042600000000000000900849000000000000000000400849000000000000000000600e49000000000000000000
// 028:d008550000001008c1d008d540081d000000000000000000d008550000001008c1d008d540081db008e5b008d5000000e008550000001008c1e008d540081d000000000000000000400805000000e008d500000040081d9008d5b008d5000000d008550000001008c1d008d540081d000000000000000000d008550000001008c1d008d540081db008e5b008d5000000e008550000001008c1e008d540081d000000000000000000d008550000000008d1000000b0085500000040081d40081d
// 029:d00847400849b00849800849071600000000000000000000000000000000000000000000000600d00847400849000000900849052600000000000000800849000000000000000831400849000000000000000000600849000000000000b00e470008c10008c10008c10008c10000000000009008478008470000000716000000000000000000000008c10008c10000000008c1000000000000000000000ec10000000000000000000008c10000000000000000000008c1000000000000000000
// 030:9008550000001008c19008d540081d0000000000000000009008550000001008c19008d540081db008e5d008d5000000b008550000001008c1b008d540081d000000000000000000400805000000b008d500000040081dd008d5b008d50000004008550000001008c14008d540081d0000000000000000004008050000001008c1b008d540081db008e5b008d50000004008550000001008c14008d540081d0000000000000000004008570000000008d100000040081df008d50008d1000000
// 031:d00847400849b00849800849071600000000000000000000000000000000000000000000000000d00e47400849000000900849052600000000000000800849000000000000000000400849000000000000000000600849000000000000400e490008c10008c10008c10008c10716000000000000000000000000000000000000000000000000000008c10008c1000000000ec14f094b00000000000080f9490000000000008ff9490008c10000008ff9490000000008c160f94900000040081b
// 032:9008550000001008c19008d540081d0000000000000000009008550000001008c19008d540081db008e5d008d5000000b008550000001008c1b008d540081d000000000000000000400805000000b008d500000040081dd008d5b008d50000004008550000001008c14008d540081d0000000000000000004008050000001008c1b008d540081db008e5b008d5000000400855000000fff949000000000000d0f9490000000000004f09490000000008d14ff94900000040081b4ff949000000
// 033:4239cb6008cbb008cbb008c94008cb6008cbb008cbb008c94008cb6008cbb008cbb008c94008cb6008cbb008cbb008c94239cb6008cbb008cbb008c94008cb6008cbb008cbb008c94008cb6008cbb008cbb008c94008cb6008cbb008cbb008c94239cb6008cbb008cbb008c94008cb6008cbb008cbb008c94008cb6008cbb008cbb008c94008cb6008cbb008cbb008c94239cb6008cbb008cbb008c94008cb6008cbb008cbb008c94008cbbff9d5d008e54008e76008d74008e7d008e5b008e5
// 034:df8929ff88294e892bbd892bdc8929fb89294a892bb9892bd88929f8992948a92bb8b92bd8c929f8d92948e92bb8f92be8f82940082b68e92bb8d92be8c92948b92b68a92bb8992be8892949892b6a892bbb892bec89294d892b6e892bbf892bdf8929ff88294e892bbd892bdc8929fb89294a892bb9892bd88929f8992948a92bb8b92bd8c929f8d92948e92bb8f92be8f82940082b68e92bb8d92be8c92948b92b68a92bb8992be8892949892b6a892bbb892bec89294d892b6e892bbf892b
// 035:8f89a90000000b61000a51000941000521000411000000000201000000000101000000000000000000000000000000001000000000000000000000008f89a90000000a61000000009008a9000000000000000000b008a90000000000000008a1bf99a90008a10d71000000000a61000000009008a98008a96f89a90d71000000000a61000000000851000000000641000000000431000000000211001000000000000000000000008f89a90000000d5100000000dff8a70000000a41000008a1
// 036:4008550000001008c14008d540081d000000000000000000400805000000000000b008e540081db008e5b008e50000004008550000001008c14008d540081d0000000000000000004008050000004008d50008d140081db008d54008d7000000e008550000001008c1e008d540081d000000000000e008d540080500000000000000000040081d9008d5b008d5000000e008550000001008c1e008d540081d000000000000000000400805000000d008d500000040081dd008d5b008d540081d
// 037:4d79a90000000a610000000008510000000006410000000004310000000002110010000048f9a966a9a98a88a9d8f9a70f88a100000006a10000000005810000000004610000000003410000000000000048f949f8f94740084966a949b8f949071600000000000000000000000000000000d00849b008490006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001008a18008490000000000001ff8a1600849000000000000
// 038:9008550000001008c19008d540081d0000000000000000004008050000000000009008e540081db008d5d008d5000000b008550000001008c1b008d540081d000000000000000000400805000000b008d500000040081d000000d008d5b008e54008550000001008c14008d540081d0000000000004008d5400805000000000000b008e540081db008e5b008e50000004008550000001008c14008d540081d000000000000000000400805000000b008d51008d140081dd008d5b008d540081d
// 039:c008550000001008c1c008d540081d0000000000000000004008050000000000009008e540081d9008e59008e5000000e008550000001008c1e008d540081d0000000000000000004008050000009008d500000040081d000000b008d50000004008550000001008c14008d540081d0000000000004008d5400805000000000000b008e540081db008e5b008e50000004008550000001008c14008d540081d0000000000000000004008054008d70008d11008d140081df008d50008d140081d
// 040:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bf8947400849b00849800849000000000000000000800849600849800849f00849800849000000000000000000000000000000000000000000000000000000000000000000000000b8594940084bf00849b008498008490000000000000000000000000000000000000000001008a14f8949000000000000100000f00847000000000000
// 041:68f949000000800849400849071600000000000000000000000000000000000000000000400e49600849800849900849052600000000000000000000800849000000000000b00e49100000800849052600000000600849000000000000000000600e49000000800849400849071600000000000000000000000000000000000000000000400e49600849800849600849000000000000000000000000400849000000000000000000f00847000000000000000000400849000000000000000000
// 042:d008550000001008c1d008d540081d000000000000000000400805000000000000d008d540081d8008d5d008d5000000c008550000001008c1c008d540081d0000000000000000004008050000008008d50008d140081d8008d5c008d5000000b008550000001008c1b008d540081d000000000000b008e540080500000000000000000040081d8008d5b008d50000006008550000001008c16008d540081d0000000000000000004008050000006008d500000040081d8008e58008e540081d
// 043:d239c9f008c94008cbb008cbd008c9f008c94008cbb008cbd008c9f008c94008cbb008cbd008c9f008c94008cbb008cbc239c9e008c94008cbb008cbc008c9e008c94008cbb008cbc008c9e008c94008cbb008cbc008c9e008c94008cbb008cbb239c9f008c94008cb8008cbb008c9f008c94008cb8008cbb008c9f008c94008cb8008cbb008c9f008c94008cb8008cba239c9d008c94008cb6008cba008c9d008c94008cb6008cba008c9d008c94008cb6008cba008c9d008c94008cb6008cb
// 044:8339a7000000000000000000000000000000000000000000000000000000000000000000d008a7000000000000000000c008a7000000000000000000000000000000000000000000e008a7000000000000000000c008a7000000000000000000b008a70000000000000000000000000000000000000000008008a7000000000000000000b008a7000000000000a85949000000000000000000b00849a00849600849d00847b00847a00847000000000000000000d00847000000000000000000
// 045:48f949000000000000000000071600000000000000000000000000000000000000000000400849000000000000000000400849000000000000000000f008470000000000000000004008490000000000000000006008490000000000004008490000000000000000000000000000000000000000000000000000000000000000000000000006000000000000000000004699c9000000000000000000d008c70000000000000000009008c70000000000000000006008c7000000000000000000
// 046:9008550000001008c19008d540081d0000000000000000004008050000000000009008d540081db008d5d008d5000000b008550000001008c1b008d540081d000000000000000000400805000000b008d50008d140081d9008d5b008d500000040085500000000000000000040081d0000000000004008d5400805000000b008d500000040081dd008d5b008d50000009008550000000000000000008008d50000000000000000006008d5000000000000000000b008d500000040081d40081d
// 047:d85947000000000000000000000000000000000000000000952947000000000000b00847d00847000000000000000000985947000000000000000000000000000000000000000000000000000000000000000000b00847000000000000800847000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b66989000000000000000000800889000000000000000000400889000000000000000000d00887000000000000120300
// 048:9239c9b008c9d008c94008cb9008c9b008c9d008c94008cb9008c9b008c9d008c94008cb9008c9b008c9d008c94008cbb008c9f008c94008cb6008cbb008c9f008c94008cb6008cbb008c9f008c94008cb6008cbb008c9f008c94008cb6008cb8008c9b008c9f008c94008cb8008c9b008c9f008c94008cb8008c9b008c9f008c94008cb8008c9b008c9f008c94008cb6969f90000000000000000004008f9000000000000000000b008f70000000000000000009008f7000000000000000000
// 049:48a9c7000000000000b008870000000000000000008008790000000000000000000000000000000000000000000000004008c90000000000000000000000008008c9000000000000000000000000000000d008c900000000000000000008a10006910008a100069100079100058100079100058100068100047100068100047100057100036100057100036100046100025100046100025100035100014100035100014100024100013100024100013100001100000100001100000100000000
// 050:4339b50551000771000991000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000224000000009338b3000000000000000000088100000000000000000000077100000000000000000000066100000000000000000000055100000000000000000000044100000000000000000000033100000000000000000000022100000000000000000000011100000000000000000000
// 051:0000006a89c7000000000000400879000000000000000000000000b00889000000000000000000000000000000000000600889000000000000000000000000b0088900000000000000000000000000000040088b0000000000000000000a81000961000a8100096100097100085100097100085100086100074100086100074100075100063100075100063100064100052100064100052100053100041100053100041100042100031100042100031100010100000100010100000100000000
// 052:0000000000008889f70000000000000000006008c9000000000000000000000000000000000000000000000000000000b00879000000000000000000000000f0087900000000000000000000000000000080087b000000000000000000088100066100088100066100077100055100077100055100066100044100066100044100055100033100055100033100044100022100044100022100033100011100033100011100022100011100022100011100011100000100011100000100000000
// </PATTERNS>

// <TRACKS>
// 000:100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ec02df
// 001:380441781842b82c00f83310254310f833958647d4d173e4f970d4d17dc41285985293107a935abaac6bfab13c3bc47d9b0000
// 002:856ad6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a00000
// 003:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ae0200
// 004:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f000ef
// </TRACKS>

// <SCREEN>
// 006:000000000000000000000000000000000003333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333000000000000000000000000000000000000
// 007:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 008:00000000000000000000000000000000000322222222222222222222222222222222222222222222222222222222222222222222222222222222cccc222222222222222222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 009:00000000000000000000000000000000000322222222222222222222222222222222222222222222222222222222222222222222222222222222cccc222222222222222222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 010:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222ccffffcc2222222222222222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 011:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222ccffffcc2222222222222222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 012:0000000000000000000000000000000000032222222222222222222222222222222222222222222222222222222222222222222222222222ccffffffcc222222222222cc22222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 013:0000000000000000000000000000000000032222222222222222222222222222222222222222222222222222222222222222222222222222ccffffffcc222222222222cc22222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 014:00000000000000000000000000000000000322222222222222222222222222222222222222222222222222222222222222222222222222ccffffffffffcc22222222cccc22222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 015:00000000000000000000000000000000000322222222222222222222222222222222222222222222222222222222222222222222222222ccffffffffffcc22222222cccc22222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 016:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222ccffffffffffffcc222222cccccc22222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 017:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222ccffffffffffffcc222222cccccc22222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 018:0000000000000000000000000000000000032222222222222222222222222222222222222222222222222222222222222222222222ccffffffffffffddffcc22ccddcc2222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 019:0000000000000000000000000000000000032222222222222222222222222222222222222222222222222222222222222222222222ccffffffffffffddffcc22ccddcc2222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 020:0000000000000000000000000000000000032222222222222222222222222222222222222222222222222222222222222222222222ccffffffffffffffddccccddcc222222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 021:0000000000000000000000000000000000032222222222222222222222222222222222222222222222222222222222222222222222ccffffffffffffffddccccddcc222222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 022:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222ccffffffffffddffccddddcc222222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 023:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222ccffffffffffddffccddddcc222222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 024:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222ccffffffffddffddccddcc22222222221155222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 025:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222ccffffffffddffddccddcc22222222221155222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 026:00000000000000000000000000000000000322222222222222222222222222222222222222222222222222222222222222222222222211ccffffddffddccddddcc55222222225544222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 027:00000000000000000000000000000000000322222222222222222222222222222222222222222222222222222222222222222222222211ccffffddffddccddddcc55222222225544222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 028:00000000000000000000000000000000000322222222222222222222222222222222222222222222222222222222222222222222115555ccffffffddffccddcc5555551122555544222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 029:00000000000000000000000000000000000322222222222222222222222222222222222222222222222222222222222222222222115555ccffffffddffccddcc5555551122555544222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 030:00000000000000000000000000000000000322222222222222222222222222222222222222222222222222222222222222221155555555ccccffddffccddddcc5555554444555544999999222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 031:00000000000000000000000000000000000322222222222222222222222222222222222222222222222222222222222222221155555555ccccffddffccddddcc5555554444555544999999222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 032:0000000000000000000000000000000000032222222222222222222222222222222222222222222222222222222222221155555555555555ccffffddccddcc444444555555555544222222992222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 033:0000000000000000000000000000000000032222222222222222222222222222222222222222222222222222222222221155555555555555ccffffddccddcc444444555555555544222222992222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 034:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222255555555555544441122ccddccddcc22221111445555555544999922229922222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 035:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222255555555555544441122ccddccddcc22221111445555555544999922229922222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 036:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222115555554422222222ccffcccc2222445555555555555544222299222299222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 037:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222115555554422222222ccffcccc2222445555555555555544222299222299222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 038:00000000000000000000000000000000000322222222222222222222222222222222222222222222222222222222222222555544222222222222cccc222222444444444444444444999922992299222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 039:00000000000000000000000000000000000322222222222222222222222222222222222222222222222222222222222222555544222222222222cccc222222444444444444444444999922992299222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 040:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222225544222222222222222222222222222222992299229999999922992299222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 041:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222225544222222222222222222222222222222992299229999999922992299222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 042:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222992288998888888899882299222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 043:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222992288998888888899882299222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 044:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222889922889999999988229988222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 045:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222889922889999999988229988222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 046:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222228899228888888822998822222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 047:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222228899228888888822998822222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 048:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222288999999999999882222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 049:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222288999999999999882222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 050:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 051:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 052:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 053:000000000000000000000000000000000003222222222222222222222222222222000000222222000000222200002222002200000000220000000022000022220022000022220022220000002222000022220022220000000022222222222222222222222222100000000000000000000000000000000000
// 054:000000000000000000000000000000000003222222222222222222222222222222000000222222000000222200002222002200000000220000000022000022220022000022220022220000002222000022220022220000000022222222222222222222222222100000000000000000000000000000000000
// 055:000000000000000000000000000000000003222222222222222222222222222200001111002200001111002200000022002211000011221100001122000000220022000022220022000011110022000022220022000000111122222222222222222222222222100000000000000000000000000000000000
// 056:000000000000000000000000000000000003222222222222222222222222222200002222002200002222002200000022002222000022222200002222000000220022000022220022000022220022000022220022000000222222222222222222222222222222100000000000000000000000000000000000
// 057:000000000000000000000000000000000003222222222222222222222222222200002222112200002222002200000000002222000022222200002222000000000022000022220022000022220022000022220022110000002222222222222222222222222222100000000000000000000000000000000000
// 058:000000000000000000000000000000000003222222222222222222222222222200002222222200002222002200000000002222000022222200002222000000000022000022220022000022220022000022220022220000002222222222222222222222222222100000000000000000000000000000000000
// 059:000000000000000000000000000000000003222222222222222222222222222200002222002200002222002200001100002222000022222200002222000011000022000022220022000022220022000022220022221100000022222222222222222222222222100000000000000000000000000000000000
// 060:000000000000000000000000000000000003222222222222222222222222222200002222002200002222002200002200002222000022222200002222000022000022000022220022000022220022000022220022222200000022222222222222222222222222100000000000000000000000000000000000
// 061:000000000000000000000000000000000003222222222222222222222222222211000000112211000000112200002211002222000022220000000022000022110022110000001122110000001122110000001122000000001122222222222222222222222222100000000000000000000000000000000000
// 062:000000000000000000000000000000000003222222222222222222222222222222000000222222000000222200002222002222000022220000000022000022220022220000002222220000002222220000002222000000002222222222222222222222222222100000000000000000000000000000000000
// 063:000000000000000000000000000000000003222222222222222222222222222222111111222222111111222211112222112222111122221111111122111122221122221111112222221111112222221111112222111111112222222222222222222222222222100000000000000000000000000000000000
// 064:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 065:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 066:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 067:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 068:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 069:000000000000000000000000000000000003222222222222222222222222222200000000000000022222200000000022222222200000000022222200000000000022222200000000022222200000000000022222200000022200022222222222222222222222100000000000000000000000000000000000
// 070:000000000000000000000000000000000003222222222222222222222222222200000000000000022222200000000022222222200000000022222200000000000022222200000000022222200000000000022222200000022200022222222222222222222222100000000000000000000000000000000000
// 071:000000000000000000000000000000000003222222222222222222222222222200000000000000022222200000000022222222200000000022222200000000000022222200000000022222200000000000022222200000022200022222222222222222222222100000000000000000000000000000000000
// 072:000000000000000000000000000000000003222222222222222222222222222200000011111111122200000011111100022200000011111100022211100000011122200000011111100022200000011111100022200000022200022222222222222222222222100000000000000000000000000000000000
// 073:000000000000000000000000000000000003222222222222222222222222222200000022222222222200000022222200022200000022222200022222200000022222200000022222200022200000022222200022200000022200022222222222222222222222100000000000000000000000000000000000
// 074:000000000000000000000000000000000003222222222222222222222222222200000022222222222200000022222200022200000022222200022222200000022222200000022222200022200000022222200022200000022200022222222222222222222222100000000000000000000000000000000000
// 075:000000000000000000000000000000000003222222222222222222222222222200000000000022222200000022222200022200000022222211122222200000022222200000022222200022200000022222200022200000000000022222222222222222222222100000000000000000000000000000000000
// 076:000000000000000000000000000000000003222222222222222222222222222200000000000022222200000022222200022200000022222222222222200000022222200000022222200022200000022222200022200000000000022222222222222222222222100000000000000000000000000000000000
// 077:000000000000000000000000000000000003222222222222222222222222222200000000000022222200000022222200022200000022222222222222200000022222200000022222200022200000022222200022200000000000022222222222222222222222100000000000000000000000000000000000
// 078:000000000000000000000000000000000003222222222222222222222222222200000011111122222200000000000000022200000022222200022222200000022222200000022222200022200000000000011122211100000011122222222222222222222222100000000000000000000000000000000000
// 079:000000000000000000000000000000000003222222222222222222222222222200000022222222222200000000000000022200000022222200022222200000022222200000022222200022200000000000022222222200000022222222222222222222222222100000000000000000000000000000000000
// 080:000000000000000000000000000000000003222222222222222222222222222200000022222222222200000000000000022200000022222200022222200000022222200000022222200022200000000000022222222200000022222222222222222222222222100000000000000000000000000000000000
// 081:000000000000000000000000000000000003222222222222222222222222222200000022222222222200000011111100022211100000000011122222200000022222211100000000011122200000011111100022222200000022222222222222222222222222100000000000000000000000000000000000
// 082:000000000000000000000000000000000003222222222222222222222222222200000022222222222200000022222200022222200000000022222222200000022222222200000000022222200000022222200022222200000022222222222222222222222222100000000000000000000000000000000000
// 083:000000000000000000000000000000000003222222222222222222222222222200000022222222222200000022222200022222200000000022222222200000022222222200000000022222200000022222200022222200000022222222222222222222222222100000000000000000000000000000000000
// 084:000000000000000000000000000000000003222222222222222222222222222211111122222222222211111122222211122222211111111122222222211111122222222211111111122222211111122222211122222211111122222222222222222222222222100000000000000000000000000000000000
// 085:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 086:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 087:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 088:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 089:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 090:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 091:000000000000000000000000000000000003222200000000000000000000000000000000000000000000000000000000000000000000000000000022220000000000000000000000000000000000000000000000000000000000000000000000000000002222100000000000000000000000000000000000
// 092:000000000000000000000000000000000003222203333333333333333333333333333333333333333333333333333333333333333333333333333022220333333333333333333333333333333333333333333333333333333333333333333333333333302222100000000000000000000000000000000000
// 093:000000000000000000000000000000000003222203222222222222222222222222222222222222222222222222222222222222222222222222221022220322222222222222222222222222222222222222222222222222222222222222222222222222102222100000000000000000000000000000000000
// 094:000000000000000000000000000000000003222203222222222222222222222222222222222222222222222222222222222222222222222222221022220322222222222222222222222222222222222222222222222222222222222222222222222222102222100000000000000000000000000000000000
// 095:000000000000000000000000000000000003222203222222222222222222222222222222222222222222222222222222222222222222222222221022220322222222222222222222222222222222222222222222222222222222222222222222222222102222100000000000000000000000000000000000
// 096:000000000000000000000000000000000003222203222222222222222222222222222222222222222222222222222222222222222222222222221022220322222222222222222222222222222222222222222222222222222222222222222222222222102222100000000000000000000000000000000000
// 097:000000000000000000000000000000000003222203222222222222222222222222222222222222222222222222222222222222222222222222221022220322222222222222222222222222222222222222222222222222222222222222222222222222102222100000000000000000000000000000000000
// 098:000000000000000000000000000000000003222203222222222222222222222222000020000220002200002200002222222222222222222222221022220322002222000002002202000002002222222220000200000200222200000220002200002222102222100000000000000000000000000000000000
// 099:000000000000000000000000000000000003222203222222222222222222222220002222002200220200220220022222222222222222222222221022220322002222002222002202002222002222222200022200222200222200222200220220022222102222100000000000000000000000000000000000
// 100:000000000000000000000000000000000003222203222222222222222222222222000222002200220200220220022222222222222222222222221022220322002222000022002202000022002222222220002200002200222200002200222220022222102222100000000000000000000000000000000000
// 101:000000000000000000000000000000000003222203222222222222222222222222200022002200000200002220022222222222222222222222221022220322002222002222200022002222002222222222000200222200222200222200220220022222102222100000000000000000000000000000000000
// 102:000000000000000000000000000000000003222203222222222222222222222220000222002200220200220220022222222222222222222222221022220322000002000002220222000002000002222200002200000200000200000220002220022222102222100000000000000000000000000000000000
// 103:000000000000000000000000000000000003222203222222222222222222222222222222222222222222222222222222222222222222222222221022220322222222222222222222222222222222222222222222222222222222222222222222222222102222100000000000000000000000000000000000
// 104:000000000000000000000000000000000003222203222222222222222222222222222222222222222222222222222222222222222222222222221022220322222222222222222222222222222222222222222222222222222222222222222222222222102222100000000000000000000000000000000000
// 105:000000000000000000000000000000000003222203222222222222222222222222222222222222222222222222222222222222222222222222221022220322222222222222222222222222222222222222222222222222222222222222222222222222102222100000000000000000000000000000000000
// 106:000000000000000000000000000000000003222203222222222222222222222222222222222222222222222222222222222222222222222222221022220322222222222222222222222222222222222222222222222222222222222222222222222222102222100000000000000000000000000000000000
// 107:000000000000000000000000000000000003222203222222222222222222222222222222222222222222222222222222222222222222222222221022220322222222222222222222222222222222222222222222222222222222222222222222222222102222100000000000000000000000000000000000
// 108:000000000000000000000000000000000003222203222222222222222222222222222222222222222222222222222222222222222222222222221022220322222222222222222222222222222222222222222222222222222222222222222222222222102222100000000000000000000000000000000000
// 109:000000000000000000000000000000000003222203111111111111111111111111111111111111111111111111111111111111111111111111111022220311111111111111111111111111111111111111111111111111111111111111111111111111102222100000000000000000000000000000000000
// 110:000000000000000000000000000000000003222200000000000000000000000000000000000000000000000000000000000000000000000000000022220000000000000000000000000000000000000000000000000000000000000000000000000000002222100000000000000000000000000000000000
// 111:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 112:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 113:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 114:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 115:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 116:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 117:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 118:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 119:000000000000000000000000000000000003222002222222222222222202222202222022222022222022220202222202222222222222222222222022220200222222222220220222222002222222222222222022000200020002222220220002000200222222100000000000000000000000000000000000
// 120:000000000000000000000000000000000003220112202200220202020212200200220002220122002102220202002212200220220202002220020102201201022002002200020022220112202202020022220022010201020112222200220102010211022222100000000000000000000000000000000000
// 121:000000000000000000000000000000000003220222010201020202001202010201021012220220112202220202010202011201020012010200120202000202020102100210120102220222010200120102221022000200020022000210220002000220122222100000000000000000000000000000000000
// 122:000000000000000000000000000000000003220222020202021002012202000202022022220220222202220202020202022202020122020211020202101202020012010220220202220222020201220202222022110201021102111220221102110221022222100000000000000000000000000000000000
// 123:000000000000000000000000000000000003221002101200122102022202110202022102221021002012221002020202100210120222020200121012202200121002000221020202221002101202220012220002220200020012222200022202220200122222100000000000000000000000000000000000
// 124:000000000000000000000000000000000003222112212201222012122212201212122212222122112122222112121212211221221222121211222122212211222112111222121212222112212212220122221112221211121122222211122212221211222222100000000000000000000000000000000000
// 125:000000000000000000000000000000000003222222222212222122222222212222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222221222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 126:000000000000000000000000000000000003222222222222222222222222222222222222222222222222202200220022222222022222022220222222222222222222222222222222222222220222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 127:000000000000000000000000000000000003222222222222222222222222222222222222222222222222010210221022220202122002002200022002220202200220022002020202022002200222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 128:000000000000000000000000000000000003222222222222222222222222222222222222222222222222000220222022220012020102010210120012220012010200120102001202020102010222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 129:000000000000000000000000000000000003222222222222222222222222222222222222222222222222010220222022220122020002020220221102220122001211020012012202020012020222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 130:000000000000000000000000000000000003222222222222222222222222222222222222222222222222020200020002220222021102020221020012220222100200121002022210121002100202222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 131:000000000000000000000000000000000003222222222222222222222222222222222222222222222222121211121112221222122012121222121122221222211211222112122221222112211212222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 132:000000000000000000000000000000000003222222222222222222222222222222222222222222222222222222222222222222222122222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222100000000000000000000000000000000000
// 133:000000000000000000000000000000000000111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111100000000000000000000000000000000000
// </SCREEN>

// <PALETTE>
// 000:00000068605cb0b0b8fcfcfc1c38ac7070fca82814fc484820880070f828b82cd0fc74ecac581cf8a8503cd4e4f8ec20
// </PALETTE>

