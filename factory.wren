// title:   Continous Factory
// author:  unicorns of DEATH
// desc:    tbd
// site:    tbd
// license: MIT License
// version: 0.1
// script:  wren

import "random" for Random

var WIDTH=240
var HEIGHT=136
var MAP_W=30
var MAP_H=17
var LEVEL=5
var TRICKY_LEVELS=6
var NUM_LEVELS=8
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

var JOB_SPAWN_TICKS=120

var CONVEYOR_TICKS=60
var JOB_TICKS=90

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

class Button {
    x { _x }
    x=(value) { _x=value }
    y { _y }
    y=(value) { _y=value }
    width { _width }
    height { _height }
    wasDown { _wasDown }
    hover { _hover }
    clicked { _clicked }
    tooltip=(value){_tooltip=value}

  construct new(x,y,w,h,bordercolor,fillcolor,hovercolor){
    _x=x
    _y=y
    _bordercolor=bordercolor
    _fillcolor=fillcolor
    _hovercolor=hovercolor
    _width=w
    _height=h
    _wasDown=false
    _wasHover=false
    _hover=false
    _clicked=false
    _tooltip=null
  }

  draw() {
    // border
    TIC.rectb(x,y,width,height,_textcolor)
    // fill
    var fillcolor=_fillcolor
    if (_hover){
        fillcolor=_hovercolor
        if (wasDown){
            fillcolor=_textcolor
        }
    }
    TIC.rect(x+1,y+1,width-2,height-2,fillcolor)
    if(_hover&&_tooltip){
        TIC.print(_tooltip,x-35,y+3,_textcolor,false,1,true)
    }
  }
 
  update() {
    var mouse=TIC.mouse()
    var mx=mouse[0]
    var my=mouse[1]
    var left=mouse[2]
    _hover=mx>=_x && mx<=_x+_width && my>=_y && my<=_y+_height
    // Change cursor: hand
    if (_hover){
      TIC.poke(0x3FFB,129)
    }
    // Clicking on press
    _clicked=false
    if (!left && _hover && _wasHover && _wasDown){
      _clicked=true
    }
    _wasHover=_hover
    _wasDown=left
  }
}

class LabelButton is Button {

  construct new(x,y,w,h,label,textcolor,fillcolor,hovercolor){
    super(x,y,w,h,textcolor,fillcolor,hovercolor)
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
  construct new(x,y,w,h,sprite,spriteW,spriteH,bordercolor,fillcolor,hovercolor){
    super(x,y,w,h,bordercolor,fillcolor,hovercolor)
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
    }

	finish() {
        return
    }

	next() {
        return this
    }

	draw() {
        return
    }

    drawWindow(x,y,w,h) {
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
        if (canSkip && (TIC.btnp(0) || TIC.btnp(1) || TIC.btnp(2) || TIC.btnp(3) || TIC.btnp(4) || TIC.btnp(5) || TIC.btnp(6) || TIC.btnp(7))) {
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
		super.draw()
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

class TitleState is State {
	construct new() {
        _startbtn=LabelButton.new(80,HEIGHT-45,80,20,"START",3,8,9)
    }

	reset() {
		super.reset()
		TIC.music(MUSTITLE,-1,-1,false)
        MUSGAMEPLAYING=false
    }

    next(){
        if(_startbtn.clicked){
            finish()
			nextstate.reset()
			return nextstate
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
        _startbtn.update()
    }

    draw() {
        super.draw()
        TIC.cls(0)
        var x=34
        var y=5
        var w=172
        var h=130
        drawWindow(x,y,w,h)
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

class ToolbarButton is ImageButton {
    construct new(sprite,availableGates,x,y,atooltip){
        super(x,y,14,12,sprite,1,1,0,1,2)
        _sprite=sprite
        _availableGates=availableGates
        tooltip=atooltip
    }

    count{_availableGates[_sprite]}

    draw(){
        // Draw greyed out if not available
        var fillcolorprev=_fillcolor
        if(count!=null&&count==0){
            _fillcolor=_bordercolor
        }
        super.draw()
        _fillcolor=fillcolorprev
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

    construct new(availableGates) {
        var xpos=(MAP_W-2)*8+2
        var ypos=16
        var dy=13
        _buttons={
            CONV_R: ToolbarButton.new(CONV_R,availableGates,xpos,ypos,"conv.belt"),
        }
        ypos=ypos+dy
        for(gateid in [DISK_GATE,APPLE_GATE,GLASS_GATE,WIN_GATE,LINUX_GATE,HAMMER_GATE]){
            if(availableGates[gateid] != null && availableGates[gateid] > 0) {
                _buttons[gateid] = ToolbarButton.new(gateid, availableGates,xpos,ypos,"logic gate")
                ypos=ypos+dy
            }
        }

        _selection=CONV_R
    }

    clicked() {
        return _buttons.values.any {|button| button.clicked }
    }

    buttonClicked() {
        return _selection
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
        for (button in _buttons) {
            button.value.draw()
        }
    }
}

class MainState is State {
    construct new() {
        _map=null
        _buildPhase=true
        _mouse=TIC.mouse()
        _toolbar=null
        _userDir=RIGHT
        _startbtn=LabelButton.new(50,1,50,9,"START",3,8,9)
        _stopbtn=LabelButton.new(50,1,50,9,"STOP",3,8,9)
        _resetbtn=LabelButton.new(105,1,50,9,"CLEAR",3,8,9)
        _speedbtn=null
        _fastforward=false
        _failed=false
        _deathticks=60
    }
    winstate { _winstate }
    winstate=(value) {
        _winstate=value
    }

    reset() {
        super.reset()
        _map=GameMap.new(LEVEL, Fn.new { failState() })
        _toolbar=Toolbar.new(_map.availableGates)
		_startbtn=LabelButton.new(50,1,50,9,"START",3,8,9)
		_stopbtn=LabelButton.new(50,1,50,9,"STOP",3,8,9)
		_resetbtn=LabelButton.new(105,1,50,9,"RESET",3,8,9)
        _speedbtn=LabelButton.new(103,1,20,9,">",0,1,2)
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

        var mousePrev=_mouse
        _mouse=TIC.mouse()

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
            }else{
                _mouseX=_mouse[0]
                _mouseY=_mouse[1]
                _mouseClick=_mouse[2]
                _mouseRightClick=_mouse[4]
                if(!_mouseClick&&mousePrev[2]==true) {
                    var tileX=(_mouseX/16).floor
                    var tileY=(_mouseY/16).floor

                    var existingBelt=_map.getConveyorBelt(tileX,tileY)
                    var existingGate=_map.getGate(tileX,tileY)
                    if(existingBelt!=null) {
                        _userDir=(existingBelt.dir+1)%4
                        _map.updateConveyorBeltDir(tileX,tileY,_userDir)
                        _toolbar.selection=ConveyorBelt.dirToMapTile(_userDir)
                    } else if(existingGate != null) {
                        _userDir=(existingGate.dir+1)%4
                        _map.updateGateDir(tileX,tileY,_userDir)
                    } else {
                        if(_toolbar.buttonClicked()==CONV_U) {
                            _userDir=UP
                            _map.addConveyorBelt(tileX, tileY, UP)
                        } else if(_toolbar.buttonClicked()==CONV_D) {
                            _userDir=DOWN
                            _map.addConveyorBelt(tileX, tileY, DOWN)
                        } else if(_toolbar.buttonClicked()==CONV_L) {
                            _userDir=LEFT
                            _map.addConveyorBelt(tileX, tileY, LEFT)
                        } else if(_toolbar.buttonClicked()==CONV_R) {
                            _userDir=RIGHT
                            _map.addConveyorBelt(tileX, tileY, RIGHT)
                        } else if(_toolbar.buttonClicked()==DISK_GATE) {
                            _map.addGate(tileX,tileY,DISK_GATE)
                        } else if(_toolbar.buttonClicked()==APPLE_GATE) {
                            _map.addGate(tileX,tileY,APPLE_GATE)
                        } else if(_toolbar.buttonClicked()==GLASS_GATE) {
                            _map.addGate(tileX,tileY,GLASS_GATE)
                        } else if(_toolbar.buttonClicked()==WIN_GATE) {
                            _map.addGate(tileX,tileY,WIN_GATE)
                        } else if(_toolbar.buttonClicked()==LINUX_GATE) {
                            _map.addGate(tileX,tileY,LINUX_GATE)
                        } else if(_toolbar.buttonClicked()==HAMMER_GATE) {
                            _map.addGate(tileX,tileY,HAMMER_GATE)
                        }
                    }
                    TIC.sfx(SFXNEXT)
                }

                if(!_mouseRightClick&&mousePrev[4]==true) {
                    var tileX=(_mouseX/16).floor
                    var tileY=(_mouseY/16).floor

                    _map.removeUserItem(tileX,tileY)
                    TIC.sfx(SFXNEXT)
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
		return super()
    }

    failState() {
        _buildPhase=true
        _map.stop()
        _failed = true
    }

    draw() {
        _map.draw()
        if(_buildPhase){
            var x=(_mouseX/16).floor*16
            var y=(_mouseY/16).floor*16
            TIC.spr(494,x,y,COLOR_KEY,1,0,0,2,2)
            TIC.print("l.click:place/rotate",x+17,y+2,3,false,1,true)
            TIC.print("r.click:remove",x+17,y+9,3,false,1,true)
        }
        TIC.rect(0,0,WIDTH,11,_buildPhase?13:9)
        TIC.print("Level:%(LEVEL+1)",2,2,0,false,1)

        // Draw next jobs window
        drawWindow(2,HEIGHT-20,WIDTH-4,19)
        TIC.print("Next:",5,HEIGHT-15,0,false,1,true)
        var jx=1.6
        _map.spawnJobs.each{|job|
            job.x=jx
            job.y=7
            job.draw()
            jx=jx+1.2
        }

        if(_buildPhase){
            TIC.print("Build Phase",WIDTH-40,3,0,false,1,true)
            _startbtn.draw()
            _resetbtn.draw()
            // Toolbar window bg
            drawWindow(WIDTH-20,13,25,HEIGHT-35)
            _toolbar.draw()
        }else{
            var time=(_map.time/60).floor
            TIC.print("Time:%(time)",WIDTH-75,3,0,false,1,true)
            _stopbtn.draw()
            _speedbtn.draw()
            TIC.print("Folders:%(_map.jobsDone)/%(_map.jobsCount)",WIDTH-48,3,0,false,1,true)
        }
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
        _nextbtn=LabelButton.new(80,HEIGHT-68,80,20,"NEXT",3,8,9)
        _flyingjobs=[]
    }
    winstate { _winstate }
    winstate=(value) {
        _winstate=value
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
            if (LEVEL==NUM_LEVELS) {
                LEVEL=0
                winstate.reset()
                return winstate
            }
            LEVEL=LEVEL+1
            nextstate.reset()
            return nextstate
        }
		return super()
    }

    update(){
        super.update()
        _nextbtn.update()
        if(LEVEL==NUM_LEVELS){
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
        super.draw()
		TIC.cls(COLOR_BG)
        var x=20
        var y=40
        var w=200
        var h=55
        drawWindow(x,y,w,h)
        if(LEVEL==NUM_LEVELS){
            TIC.print("CONGRATULATIONS!",x+7,y+5,0,false,2)
            y=y+14
            TIC.print("Game complete!",x+7,y+5,0,false,1)
        }else{
            TIC.print("LEVEL %(LEVEL+1) COMPLETE",x+7,y+5,0,false,2)
            if(LEVEL+1==TRICKY_LEVELS){
                y=y+14
                TIC.print("Challenging levels ahead!",x+7,y+5,0,false,1)
            }
        }
        if(LEVEL==NUM_LEVELS){
            _flyingjobs.each{|fj|
                fj.draw()
            }
        }
        _nextbtn.draw()
    }
}

class HelpState is State {
	construct new() {
        _read=false
        _startbtn=LabelButton.new(95,HEIGHT-20,50,9,"START",3,8,9)
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
        _startbtn.update()
    }

	draw() {
		super.draw()
		TIC.cls(COLOR_BG)
        var x=30
        var y=5
        var w=180
        var h=125
        var fh=FONTH+2
        drawWindow(x,y,w,h)
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
        var frame=(_ticks/8).floor%4
        if (_dir==DOWN) {
            TIC.spr(288+frame*2,x,y,COLOR_KEY,1,0,0,2,2)
        } else if (_dir==UP) {
            TIC.spr(294-frame*2,x,y,COLOR_KEY,1,0,0,2,2)
        } else if (_dir==LEFT) {
            TIC.spr(326-frame*2,x,y,COLOR_KEY,1,0,0,2,2)
        } else if (_dir==RIGHT) {
            TIC.spr(320+frame*2,x,y,COLOR_KEY,1,0,0,2,2)
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
        var frame=(_ticks/15).floor%3
        palset(5,15)
        palset(4,13)
        TIC.spr(256+frame*2,x,y,COLOR_KEY,1,0,0,2,2)
        palset(null,null)
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
        var frame=2-((_ticks/15).floor%3)
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
        if(dir==0){
            _trueDir=RIGHT
            _falseDir=LEFT
        }else if(dir==1){
            _trueDir=UP
            _falseDir=DOWN
        }else if(dir==2){
            _trueDir=LEFT
            _falseDir=RIGHT
        }else{
            _trueDir=DOWN
            _falseDir=UP
        }
    }

    dir {_dir}
    task{_task}
    trueDir{_trueDir}
    falseDir{_falseDir}

    passes(job){
        return job.containsTask(_task)
    }

    draw() {
        TIC.spr(264,x,y,COLOR_KEY,1,0,0,2,2)
        TIC.spr(_task,x+4,y+5,COLOR_KEY)
        if((_ticks%30)>8){
            if(_trueDir==RIGHT){
                TIC.spr(266,x+8,y+4,COLOR_KEY)
            }else if(_trueDir==DOWN){
                TIC.spr(267,x+4,y+8,COLOR_KEY)
            }else if(_trueDir==LEFT){
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
    
    construct new(i, killStateFunction) {
        _started=false
        _time=0
        _userTiles=[EMPTY_TILE,CONV_U,CONV_D,CONV_L,CONV_R]
        _userTiles.addAll((64..69).toList)
        _userTiles.addAll((80..85).toList)
        _userTiles.addAll((96..101).toList)
        _userTiles.addAll((112..117).toList)
        _conveyorBelts=[]
        _killStateFunction=killStateFunction
        for(i in 1..MAP_H) {
            _conveyorBelts.add(List.filled(MAP_W, null))
        }
        _factories=[]
        _gates=[]
        _availableGates={}
        for(i in 1..MAP_H) {
            _gates.add(List.filled(MAP_W, null))
        }
        _building=true
        for(x in 0..MAP_W/2) {
            for(y in 0..MAP_H/2){
                var tileId=getTileId(x,y)
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
                    _gates[x][y]=Gate.new(x,y,tileId)
                }
            }
        }
        _building=false
        // Load available gates to place
        for(x in MAP_W-1..0){
            for(y in MAP_H-1..9){
                var tileId=getTileId(x,y)
                if(tileId==CONV_R||tileId==DISK_GATE||tileId==APPLE_GATE||tileId==GLASS_GATE||tileId==WIN_GATE||tileId==LINUX_GATE||tileId==HAMMER_GATE){
                    if(_availableGates[tileId]==null){
                        _availableGates[tileId]=0
                    }
                    _availableGates[tileId]=_availableGates[tileId]+1
                }else{
                    break
                }
            }
            if(_availableGates.count==0){
                // No more gates
                break
            }
        }
        softreset(false)
    }

    time{_time}
    spawnJobs{_spawnJobs}
    jobsCount{_jobsCount}
    jobsDone{_jobsDone}
    haswon{jobsDone==jobsCount&&_flyingjobs.count==0}
    availableGates{_availableGates}

    softreset(resetTiles) {
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
            job.ticks=CONVEYOR_TICKS
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
            _conveyorBelts.each {|conveyorBeltColumn|
                conveyorBeltColumn.each {|conveyorBelt|
                    if(conveyorBelt!=null) {
                        var tileX=(conveyorBelt.x/16).floor
                        var tileY=(conveyorBelt.y/16).floor
                        removeUserItem(tileX, tileY)
                    }
                }
            }
            _gates.each {|gateColumn|
                gateColumn.each {|gate|
                    if(gate!=null) {
                        var tileX=(gate.x/16).floor
                        var tileY=(gate.y/16).floor
                        removeUserItem(tileX, tileY)
                    }
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
        var tileId=ConveyorBelt.dirToMapTile(dir)
        if (_availableGates[CONV_R]==null||_availableGates[CONV_R] > 0) {
            removeUserItem(x,y)
            _conveyorBelts[x][y]=ConveyorBelt.new(x,y,dir)
            var xstart=(LEVEL%8)*MAP_W
            var ystart=(LEVEL/8).floor*MAP_H
            TIC.mset(xstart+x,ystart+y,tileId)
            updateGateCount(CONV_R,-1)
        }
    }

    getConveyorBelt(x,y) {
        return _conveyorBelts[x][y]
    }

    removeUserItem(x,y) {
        var currentTile=getTileId(x,y)
        if(!_userTiles.contains(currentTile)) return
        if(_conveyorBelts[x][y]!=null){
            // Removing belt
            _conveyorBelts[x][y]=null
            if(currentTile==CONV_R||currentTile==CONV_L||currentTile==CONV_U||currentTile==CONV_D){
                currentTile=CONV_R
            }
        }else if(_gates[x][y]!=null){
            // Removing gate
            _gates[x][y]=null
            currentTile=80+(currentTile%16)
        }
        updateGateCount(currentTile,1)
        var xstart=(LEVEL%8)*MAP_W
        var ystart=(LEVEL/8).floor*MAP_H
        TIC.mset(xstart+x,ystart+y,0)
    }

    updateConveyorBeltDir(x,y,dir) {
        removeUserItem(x,y)
        addConveyorBelt(x,y,dir)
    }

    addGate(x,y,tileId) {
        if (_availableGates[tileId] > 0) {
            updateGateCount(tileId,-1)
            _gates[x][y]=Gate.new(x,y,tileId)
            var xstart=(LEVEL%8)*MAP_W
            var ystart=(LEVEL/8).floor*MAP_H
            TIC.mset(xstart+x,ystart+y,tileId)
        }
    }

    updateGateCount(tileId,d){
        if(!_building&&_availableGates[tileId]!=null){
            _availableGates[tileId]=_availableGates[tileId]+d
        }
    }

    getGate(x,y) {
        return _gates[x][y]
    }

    updateGateDir(x,y,dir) {
        var task=_gates[x][y].task
        removeUserItem(x,y)
        _gates[x][y]=Gate.new(x,y,task,dir)
        var tileId=Gate.toMapTile(task,dir)
        var xstart=(LEVEL%8)*MAP_W
        var ystart=(LEVEL/8).floor*MAP_H
        TIC.mset(xstart+x,ystart+y,tileId)
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
        var xstart=(LEVEL%8)*MAP_W
        var ystart=(LEVEL/8).floor*MAP_H
        return TIC.mget(xstart+x,ystart+y)
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
        var xstart=(LEVEL%8)*MAP_W
        var ystart=(LEVEL/8).floor*MAP_H

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
                var tileId=TIC.mget(xstart+x,ystart+y)
                if(tileId==IN_TILE){
                    job.moveRight()
                    job.ticks=CONVEYOR_TICKS
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
                    job.ticks=CONVEYOR_TICKS
                }else if(tileId==CONV_L){
                    job.moveLeft()
                    job.ticks=CONVEYOR_TICKS
                }else if(tileId==CONV_U){
                    job.moveUp()
                    job.ticks=CONVEYOR_TICKS
                }else if(tileId==CONV_D){
                    job.moveDown()
                    job.ticks=CONVEYOR_TICKS
                }else if(tileId==DISK||tileId==APPLE||tileId==GLASS||tileId==WIN||tileId==LINUX||tileId==HAMMER){
                    if(job.containsTask(tileId)){
                        job.doTask(tileId)
                        job.ticks=JOB_TICKS
                        // We still need to stay at this factory, don't move yet
                        job.moving=false
                        TIC.sfx(SFXCOMPLETE)
                    }else{
                        job.ticks=CONVEYOR_TICKS
                        job.moving=true
                    }
                }else if(_gates[x][y]!=null){
                    var gate=_gates[x][y]
                    job.ticks=CONVEYOR_TICKS
                    if(gate.passes(job)){
                        job.moveDir(gate.trueDir)
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
            job.x=_inTile.x/16
            job.y=_inTile.y/16
            _jobs.add(job)
            TIC.sfx(SFXSPAWN)
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
        var helpState = HelpState.new()
        var mainState = MainState.new()
        var winState = WinState.new()
        splashState.nextstate = titleState
        titleState.nextstate = helpState
        helpState.nextstate = mainState
        mainState.winstate = winState
        winState.nextstate = mainState
        winState.winstate = splashState
        _state=splashState
        _state.reset()
	}
	
	TIC(){
        TIC.cls(COLOR_BG)

        _state.update()
        _state.draw()
        _state=_state.next()
	}
}

class Request {
    construct new() {

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
        _spawning=true
        _r=0
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
        var d=(_moving&&!_blocked)?1-_ticks*1.0/CONVEYOR_TICKS:0
        var drawx=(x+_dx*d*d)*16
        var drawy=(y+_dy*d*d)*16
        TIC.spr(352,drawx-4,drawy-4,COLOR_KEY,1,0,_r,3,3)
        if(isComplete){
            TIC.spr(355,drawx,drawy,0,1,0,0,2,2)
        }
        for (task in _tasks) {
            TIC.spr(task.key,drawx,drawy,COLOR_KEY)
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
        if(_spawning){
            _r=(_ticks/5).floor%4
        }else{
            _r=0
        }
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
// 016:00000000000000000f0f00f00f0ff0f00f0f0ff00f0f00f00f0f00f000000000
// 017:0000000000000000090809999098089090980890909808900908889000000000
// 018:9999999999993999999933999333333993333339999933999999399999999999
// 019:9999999999939999993399999333333993333339993399999993999999999999
// 020:9999999999933999993333999333333999933999999339999993399999999999
// 021:9999999999933999999339999993399993333339993333999993399999999999
// 032:9000009905225509052255090555550905333509053335099000009999999999
// 033:9990809990080099088088090ffff0990dddd099077777090aaaaa0990505099
// 034:9000099901221099023e209902ee209901221f099000cdf099990c0999999099
// 048:990000999007800900778809907ef80900eeff0990e00f090009900999999999
// 049:900000990000000903303309031013090fffff0903ddd3090333330999999999
// 050:99999999990099999020999902100000011cccc0901000000111099990009999
// 064:9000009900225509070250e0770550ee070330e0003335099000009999999999
// 065:999080999008009900808809070ff0e0770dd0ee070770e000aaaa0990505099
// 066:9000099901221099003e2009070e20e0770210ee0700c0e090990c0999999099
// 067:990000999007800900778809070ef0e0770ef0ee070000e00009900999999999
// 068:900000990000000900303309070010e0770ff0ee070dd0e00033330999999999
// 069:999999999900999990209909071000e0771cc0ee971000e00111090990009999
// 080:900e009900eee009050005090555550905333509053000099007770999907099
// 081:990e009990eee099080008090ffff0990dddd099077000090a07770990507099
// 082:900e099900eee0990200009902ee209901221f09900000f09907770999907099
// 083:990e009990eee00900000809907ef80900eeff0990e000090007770999907099
// 084:900e009900eee00903000309031013090fffff0903d000090307770999907099
// 085:990e099990eee0999000099902100000011cccc0901000000107770990007099
// 096:90000099002255090e025070ee0550770e033070003335099000009999999999
// 097:9990809990080099008088090e0ff070ee0dd0770e07707000aaaa0990505099
// 098:9000099901221099003e20090e0e2070ee0210770e00c07090990c0999999099
// 099:9900009990078009007788090e0ef070ee0ef0770e0000700009900999999999
// 100:9000009900000009003033090e001070ee0ff0770e0dd0700033330999999999
// 101:9999999999009999902099090e000070ee0cc0770e0000700011090990009999
// 112:900700990077700905000509055555090533350905300009900eee099990e099
// 113:9907009990777099080008090ffff0990dddd099077000090a0eee099050e099
// 114:90070999007770990200009902ee209901221f09900000f0990eee099990e099
// 115:990700999077700900000809907ef80900eeff0990e00009000eee099990e099
// 116:900700990077700903000309031013090fffff0903d00009030eee099990e099
// 117:99070999907770999000099902100000011cccc090100000010eee099000e099
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
// 032:9000000001111111011111110000000002222222022222220111111100000000
// 033:0000000911111110111111100000000022222220222222201111111000000000
// 034:9000000001111111022222220111111100000000022222220222222201111111
// 035:0000000911111110222222201111111000000000222222202222222011111110
// 036:9000000001111111022222220222222201111111000000000222222202222222
// 037:0000000911111110222222202222222011111110000000002222222022222220
// 038:9000000001111111000000000222222202222222011111110000000002222222
// 039:0000000911111110000000002222222022222220111111100000000022222220
// 044:2254222222222222222222222222222222222222222222222222222222222222
// 045:2222222222222222222222222222222222222222222222222222222222222222
// 046:2229292922292898222892892222892822222899222222222222222222222222
// 047:9992929288898292999829828882982299998222222222222222222222222222
// 048:0222222202222222011111110000000002222222022222220111111190000000
// 049:2222222022222220111111100000000022222220222222201111111000000009
// 050:0000000002222222022222220111111100000000022222220111111190000000
// 051:0000000022222220222222201111111000000000222222201111111000000009
// 052:0111111100000000022222220222222201111111000000000111111190000000
// 053:1111111000000000222222202222222011111110000000001111111000000009
// 054:0222222201111111000000000222222202222222011111110111111190000000
// 055:2222222011111110000000002222222022222220111111101111111000000009
// 064:9000000002012201120122011201220112012201120122011201220112012201
// 065:0000000922012200220122012201220122012201220122012201220122012201
// 066:9000000002201220122012201220122012201220122012201220122012201220
// 067:0000000912201220122012211220122112201221122012211220122112201221
// 068:9000000001220122112201221122012211220122112201221122012211220122
// 069:0000000901220120012201210122012101220121012201210122012101220121
// 070:9000000000122012101220121012201210122012101220121012201210122012
// 071:0000000920122010201220112012201120122011201220112012201120122011
// 080:1201220112012201120122011000000002622222067622220262222290000000
// 081:2201220122012201220122010000000122226260222227202222626000000009
// 082:1220122012201220122012201000000006262222027222220626222290000000
// 083:1220122112201221122012210000000122222620222267602222262000000009
// 084:1122012211220122112201221000000002622222067622220262222290000000
// 085:0122012101220121012201210000000122226260222227202222626000000009
// 086:1012201210122012101220121000000006262222027222220626222290000000
// 087:2012201120122011201220110000000122222620222267602222262000000009
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
// 119:9cffffdf99cffdfd99cfffdf99ccfdfc999cffdc9999cdcd9999cfcc99999cc9
// 120:dcdc9999cddc9999cdc99999ddc99999dc999999c99999999999999999999999
// 121:cfffffdfcffffdfd9cffdfdf99cffdfd999cffdf9999cdfd99999ccf9999999c
// 122:cdfdfffccfdfffcccdfdfc99cfdfc999cdfc9999cfc99999cc999999c9999999
// 123:9999cdcd9999cddc99999cdc99999cdd999999cd9999999c9999999999999999
// 124:fdffffc9dfdffc99fdfffc99cfdfcc99cdffc999dcdc9999ccfc99999cc99999
// 128:99cfffff99cfffff99cfffff990dfdfd99cfdfdf990dfdfd9990000099994444
// 129:fffffffffdfdfdfddfdfdfdffdfdfdfddfdfdfdffdfdfdfd0000000044444444
// 130:fffff099fdfdf099dfdfd099fdfdf099dfdfd099fdfdf0990000049944444499
// 144:9900000000000000000000000000000000000000000000000000000000000000
// 238:3339999939999999399999999999999999999999999999999999999999999999
// 239:9999933399999993999999939999999999999999999999999999999999999999
// 254:9999999999999999999999999999999999999999399999993999999933399999
// 255:9999999999999999999999999999999999999999999999939999999399999333
// </SPRITES>

// <MAP>
// 002:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002103000000000000000000000000000000000000000000000000000000000011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000051000000000000000000000000000000000000000000000000
// 003:000000000000000000000000000000000000000000000000000000000000000000012121122100000000000000000000000000000000000000000000000000010000120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000021225100000000000000000000000000000000000000000000000000000041020031000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000
// 004:000000012121020011000000000000000000000000000000000000000000000000000000005100000000000000000000000000000000000000000000000000000000001351000000000000000000000000000000000000000000000000000041220000000000000000000000000000000000000000000000000000012105002111000000000000000000000000000000000000000000000000012105002211000000000000000000000000000000000000000000000000000001212200000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000
// 005:000000000000000000000000000000000000000000000000000000000000000000000000001100000000000000000000000000000000000000000000000000000000000011000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000021024100000000000000000000000000000000000000000000000000000031000031000000000000000000000000000000000000000000000000000000000011000000000000000000000000000000000000000000000000001200110000000000000000000000000000000000000000000000
// 006:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000410031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000312341000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 012:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000021000000000000000000000000000000000000000000000000000000000005000000000000000000000000000000000000000000000000000000000000
// 013:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000021000000000000000000000000000000000000000000000000000000000021000000000000000000000000000000000000000000000000000000000000
// 014:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005000000000000000000000000000000000000000000000000000000000021000000000000000000000000000000000000000000000000000000000015
// 015:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000300030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000021000000000000000000000000000000000000000000000000000000000000000000000200220000000000000000000000000000000000000000212121000002000000000000000000000000000000000000000000000000000021000000000000000000000000000000000000000000000000000000000005
// 016:020202020000000000000000000000000000000000000000000000000000121212120000000000000000000000000000000000000000000000000000031213031300000000000000000000000000000000000000000000000000222222000000000000000000000000000000000000000000000000000021022202220000000000000000000000000000000000000000000000000005020222230223220000000000000000000000000000000000000000000055220222000000000000000000000000000000000000000000000000000021021200000000000000000000000000000000000000000000000000000021
// 020:000000000000000012000000000000000000000000000000000000000000000000000000000012000000000000000000000000000000000000000000000000000000000012000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000263626362636263626366474000000000000657526362636263626362636000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000263626362636647400000000657526362636263626362636263626362636
// 021:000000000000002311220000000000000000000000000000000000000000000000000000002311220000000000000000000000000000000000000000000000000000002311220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000273727372737253525352535647400006575253525352535273727372737000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000273725352535253564746575253525352535273727372737273727372737
// 022:000000000121000013000000000000000000000000000000000000000000000000000121000013000000000000000000000000000000000000000000000000000121000013000000000000000000000000000000000000000000001000100010001000100010001000100010001000100010001000100010001000100010465625352636263626362636263625354757001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001046562535263626362636263625354757001000100010001000100010
// 023:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011101110111011101110111011101110111011101110111011101110111011101110111011146562737273727372737273747570111011101110111011101110111011101110313031303130313031301110111011101110111011101110111011101110111011101110111011101110111011101110111011101114656273727372737273747570111011101110111011101110111
// 024:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000203020302030203020302030021202120212203020302030203020302030203020302030203020300010001000100010001020302030203020302030203020302030203045552434243424342434243444542030203020302030203020302030203020302030203020302030203020302030203020302030203020302030001000100010001020302030203020302030203020302030
// 025:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000213121312131213121312131031303130313213121312131213121312131213121312131213121310111011101110111011121312131213121312131213121312131213146562737273727372737273747572131213121312131213121312131213121310313031303130313031321312131213121312131213121312131011101110111011121312131213121312131213121312131
// 026:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000203020302030021202124555243424342434445402120212203020302030203020302030203020300212021202120212021220302030203020302030203020302030203020300010001000100010001020302030203020302030203020302030203045552434243424342434243444542030203020302030203020302030203020302030203020302030021202120212021220302030
// 027:000000000000000000000000000000000000000000000000000000000055000000000000000000000000000000000000000000000000000000000055000000000000000000000000000000000000000000000000000000000055213121312131031345552535253525352535253544540313213121312131213121312131213121310313031303130313031321312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213146562737273727372737273747572131213121312131213121312131213121312131213121312131031303130313031321312131
// 028:000000000000000000000000000000000000000000000000000000000021000000000000000000000000000000000000000000000000000000000021000000000000000000000000000000000000000000000000000000000021021202124555243425352535253567762535253525352434445402120212021202120212021245552434243424342434243444540212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120010001000100010001002120212021202120212021202120212021202120212021202124555243424342434243444540212
// 029:000000000000000000000000000000000000000000000000000000000021000000000000000000000000000000000000000000000000000000000021000000000000000000000000000000000000000000000000000000000021031345552535253525352535677705156676253525352535253544540313031303130313455525352535253525352535253525354454031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031345552535253525352535253525354454
// 030:000000000000000000000000000000000000000000000000000000000021000000000000000000000000000000000000000000000000000000000021000000000000000000000000000000000000000000000000000000000021243425352535253567770404040404040404040466762535253525352434243424342434253525352535677704046676253525352535243424342434040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404243424342434243424342434243425352535253567776676253525352535
// 031:000000000000000000000000000000000000000000000000000000000021000000000000000000000000000000000000000000000000000000000021000000000000000000000000000000000000000000000000000000000021253525352535677704040404040404040404040404046676253525352535253525352535253525356777040404040404667625352535253525352535040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404253525352535253525352535253525352535677704040404667625352535
// 032:231322120000000000000000000000000000000000000000000000000021231322120000000000000000000000000000000000000000000000000021231322120000000000000000000000000000000000000000000000000021040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 033:132212230000000000000000000000000000000000000000000000000021132212230000000000000000000000000000000000000000000000000021132212230000000000000000000000000000000000000000000000000021040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 034:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 035:040404040404040404040404040404040404040404040404040404040404040404040404657526362636263626362636263626366474040404040404040404040404040404040404040404040404040404040404040404040404040404040404657526362636263626362636263626366474040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 036:040404040404040404040404040404040404040404040404040404040404040404046575253525352535273727372737253525352535647404040404040404040404040404040404040404040404040404040404040404040404040404046575253525352535273727372737253525352535647404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 037:263626362636263626362636263626362636647404040404657526362636263626362636263625354757001000100010465625352636263626362636040404040404040404040404040404040404040404040404040404040404263626362636263625354757001000100010465625352636263626362636263626366474040404040404040404040404040404040404657526362636040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 038:273727372737273727372737273725352535253564746575253525352535273727372737273747570111011101110111011146562737273727372737040404040404040404040404040404040404040404040404040404040404273727372737273747570111011101110111011146562737273727372737253525352535647404040404040404040404040404046575253525352737040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 039:001000100010001000100010001046562535263626362636263625354757001000100010001020302030203020302030203020300010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001002120212021202120212021202120010001000100010465625352636263626362636647404140404657526362636263625354757001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010
// 040:011101110111011101110111011101114656273727372737273747570111011101110111011121312131213121312131213121310111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011146562737273725352535253564746575253525352737273747570111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111
// 041:203020302030203020302030203020302030001000100010001020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030021202120212203020302030203020302030203020300010001046562535263626362636253547570010001020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030
// 042:213121312131213121312131213121312131011101110111011121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131031303130313213121312131213121312131213121310111011101114656273727372737475701110111011121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131
// 043:203020302030021202120212021220302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020300212021202124555243424342434445402120212203020302030203020302030203020302030001000100010203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030
// 044:213121312131031303130313031321312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121310313031345552535253525352535253544540313213121312131213121312131213121312131011101110111213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131
// 045:021202124555243424342434243444540212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021245552434243425352535253567762535253525352434445402120212021202120212021220302030203020302030203020300212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212
// 046:031345552535253525352535253525354454031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313011101110111011101110111011101110313031303130313455525352535253525352535677705156676253525352535253544540313031303130313031321312131213121312131213121310313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313
// 047:243425352535253567776676253525352535243424342434243424342434040404040404040404040404040404040404040404040404667626362434243424342434445402120212021202120212021245552434243424342434253525356777040404040404040404040404040466762535253525352434243424342434243444540212021202120212021245552434243424342434040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 048:253525352535677704040404667625352535253525352535253525352535040404040404040404040404040404040404040404040404040466762535253525352535253544540313031303130313455525352535253525352535253567770404040404040404040404040404040404046676253525352535253525352535253525354454031303130313455525352535253525352535040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 049:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040466762535253525352434243424342434253525352535677704040404040404040404040404040404040404040404040404040404040404040404040404046676253525352535243424342434253525352535677704040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 050:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404046676253525352535253525352535253525356777040404040404040404040404040404040404040404040404040404040404040404040404040404040404667625352535253525352535253525356777040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 051:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 052:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 053:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 054:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404657526362636263626362636263626366474040404040404
// 055:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404046575253525352535273727372737253525352535647404040404
// 056:040404040404040404040404040404040404040404040404040404040404263626362636263626366474040404040404657526362636263626362636263626362636263626366474041404140414657526362636263626362636263626362636647404040404040404040404040404046575263626362636040404040404040404040404040404040404040404040404040404040404263626362636647404046575263626362636263626362636263626362636263626362636263626362636263626362636647404046575263626362636263626362636263625354757001000100010465625352636263626362636
// 057:040404040404040404040404040404040404040404040404040404040404273727372737253525352535647404046575253525352535273727372737273727372737253525352535647405156575253525352535273727372737273725352535253564740404040404040404040465752535253525352737040404040404040404040404040404040404040404040404040404040404273725352535253564752535253525352737273727372737273727372737273727372737273727372737273725352535253564752535253525352737273727372737273747570111011101110111011146562737273727372737
// 058:001000100010001000100010001000100010001000100010001000100010001000100010465625352636263626362636263625354757001000100010001000100010465625352636263626362636263625354757001000100010001046562535263626362636647404146575263626362636253547570010001000100010001000100010001000100010001000100010001000100010001046562535263626362636253547570010001000100010001000100010001000100010001000100010001046562535263626362636253547570010001000100010001002120212021202120212021202120010001000100010
// 059:011101110111011101110111011101110111011101110111011101110111011101110111011146562737273727372737273747570111011101110111011101110111011146562737273727372737273747570111011101110111011101114656273725352535253564752535253525352737475701110111011101110111011101110111031303130313011101110111011101110111011101114656273727372737475701110111011101110111011101110111011101110111011101110111011101114656273727372737475701110111011101110111011101110111011101110111011101110111011101110111
// 060:203020302030203020300212021202120212021220302030203020302030203020302030203020300010001000100010001020302030203020302030203020302030203020300010001000100010001020302030203020302030203020302030001046562535263626362636253547570010203020302030203020302030021202124555243424342434445402120212203020302030203020302030001000100010203020302030021202120212203020302030203020302030021202120212203020302030001000100010203020302030203020302030203020302030203020302030203020302030203020302030
// 061:213121312131213121310313031303130313031321312131213121312131213121312131213121310111011101110111011121312131213121312131213121312131213121310313031303130313031321312131213121312131213121312131011101114656273727372737475701110111213121312131213121312131031345552535253525352535253544540313213121312131213121312131011101110111213121312131031303130313213121312131213121312131031303130313213121312131011101110111213121312131213121312131213121312131213121312131213121312131213121312131
// 062:021202120212021245552434243424342434243444540212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021245552434243424342434243444540212021202120212021202120212021202120212001000100010021202120212021202120212021202124555243425352535253567762535253525352434445402120212021202120212021202120212021202124555243424342434445402120212021202124555243424342434445402120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212
// 063:031303130313455525352535253525352535253525354454031303130313031303130313031303130313031303130313031303130313031303130313031303130313455525352535253525352535253525354454031303130313031303130313031303130313031303130313031303130313031303130313031345552535253525352535677705156676253525352535253544540313031303130313031303130313031345552535253525352535253544540313031345552535253525352535253544540313031303130313031303130313031303130313031303130313031303130313031303130313031303130313
// 064:243424342434253525352535677704046676253525352535243424342434040404040404040404040404040404040404040404040404040404040404243424342434253525352535677704046676253525352535243424342434040404040404040404040404040404040404040404040404040404040404243425352535253567770404040404040404040466762535253525352434243424342434243424342434243425352535253567762535253525352434243425352535253567762535253525352434243424342434243424342434040404040404040404040404040404040404040404040404040404040404
// 065:253525352535253525356777040404040404667625352535253525352535040404040404040404040404040404040404040404040404040404040404253525352535253525356777040404040404667625352535253525352535040404040404040404040404040404040404040404040404040404040404253525352535677704040404040404040404040404046676253525352535253525352535253525352535253525352535677704046676253525352535253525352535677704046676253525352535253525352535253525352535040404040404040404040404040404040404040404040404040404040404
// 066:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 067:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 068:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 069:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 070:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 071:040404040404040404040404040404040404040404040404040404040404040404040404657526362636263626362636263626366474040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 072:040404040404040404040404040404040404040404040404040404040404040404046575253525352535273727372737253525352535647404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 073:040404040404040404040404040404040404040404040404040404040404263626362636263625354757001000100010465625352636263626362636263626366474040404040404040404040404040404040404657526362636040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 074:040404040404040404040404040404040404040404040404040404040404273727372737273747570111011101110111011146562737273727372737253525352535647404040404040404040404040404046575253525352535040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 075:001000100010001000100010001000100010001000100010001000100010001000100010001002120212021202120212021202120010001000100010465625352636263626362636647404146575263626362636263625354757001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010
// 076:011101110111011101110111011101110111011101110111011101110111011101110111011101112131031303130313011101110111011101110111011146562737273725352535253564752535253525352737273747570111011101110111011101110313031303130313031301110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111
// 077:203020302030203020302030203020302030203020302030203020302030203020300212021202124555243424342434445402120212021220302030203020300010001046562535263626362636253547570010001020302030203020302030203045552434243424342434243444542030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030
// 078:213121312131213121312131213121312131213121312131213121312131213121310313031345552535253525352535253544540313031321312131213121310111011101114656273727372737475701110111011121312131213121312131213146562737273727372737273747572131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131
// 079:021202120212021202120212021202120212021202120212021202120212021245552434243425352535253567762535253525352434243444540212021202120212021202120212001000100010021202120212021202120212021202120212021202120010001000100010001002120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212
// 080:031303130313031301110111011101110111011101110313031303130313455525352535253525352535677705156676253525352535253525354454031303130313031301110111011101110111011101110313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313
// 081:243424342434243444540212021202120212021245552434243424342434253525352535677704040404040404040404040404046676253525352535243424342434243444540212021202120212021245552434243424342434040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 082:253525352535253525354454031303130313455525352535253525352535253525356777040404040404040404040404040404040404667625352535253525352535253525354454031303130313455525352535253525352535040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 083:040404046676253525352535243424342434253525352535677704040404040404040404040404040404040404040404040404040404040404040404040404046676253525352535243424342434253525352535677704040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 084:040404040404667625352535253525352535253525356777040404040404040404040404040404040404040404040404040404040404040404040404040404040404667625352535253525352535253525356777040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 085:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 086:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040465752636263626362636263664740404040404040404040404040404040404040404040404040404040404040404040404040404
// 087:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404657525352535253527372535253525356474040404040404040404040404040404040404040404040404040404040404040404040404
// 088:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040465752636263626362636263664740404040404040404040404040404040404040404040404040404040404040404040404040404040404046575263626362535475700104656253526362636647404040404040404040404040404040404040404040404040404040404040404040404
// 089:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404657525352535253527372535253525356474040404040404040404040404040404040404040404040404040404040404040404040404040465752535253525354757011101110111465625352535253564740404040404040404040404040404040404040404040404040404040404040404
// 090:263626362636263626362636263626362636263626362636263626362636263626362636263664740404040404040404040465752636263626362636263626362636647404046575263626362636263626362636263626362636263626362636647404046575263626362636263626362636263626362636263626362636263626362535475700104656253526362636263626362636263626362636263626362636263626362636263626362636263626362636263626362636253547570212021202120212021246562535263626362636263626362636263626362636263626362636263626362636263626362636
// 091:273727372737273727372737273727372737273727372737273727372737273727372535253525356474040404040404657525352535253527372737273725352535253564752535253525352737273727372737273727372737273725352535253564752535253525352737273727372737273727372737273727372737273727374757011101110111465627372737273727372737273727372737273727372737273727372737273727372737273727372737273727372737475701110111011101110111011101114656273727372737273727372737273727372737273727372737273727372737273727372737
// 092:001000100010001010100010001000100010001000100010001000100010001000104656253526362636263626362636263626362535475700100010001046562535263626362636253547570010001000100010001000100010001046562535263626362636253547570010001000100010001000100010001000100010001000100212021202120212021200100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010021202120212021202120212021202120212001000100010001000100010001000100010001000100010001000100010001000100010
// 093:011101110111011113130313031303130313031303130111011101110111011101110111465627372737273727372737273727374757011101110111011101114656273727372737475701110111031303130313011101110111011101114656273727372737475701110111031303130313011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111
// 094:021202120212455524342434243424342434243424344454021202120212021202120212021200100010001000100010001000100212021202120212021202120212001000100010021202124555243424342434445402120212021202120212001000100010021202124555243424342434445402120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212
// 095:031303134555253525352535253525352535253525352535445403130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031345552535253525352535253544540313031303130313031303130313031345552535253525352535253544540313031303130313031303130313031303130313031303130313031303130313031303130313031303130111011101110111011103130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313011101110111011101110111011101110111031303130313
// 096:243424342535253525356777040404040404667625352535253524342434243424342434243424342434243424342434243424342434243424342434243424342434243424342434243425352535253567762535253525352434243424342434243424342434243425352535253567762535253525352434243424342434243424342434243424342434243424342434243424342434243424342434243424344454021202120212455524342434243424342434243424342434243424342434243424342434243424342434243424342434243424342434445402120212021202120212021202124555243424342434
// 097:253525352535253567770404040404040404040466762535253525352535253525352535253525352535253525352535253525352535253525352535253525352535253525352535253525352535677704046676253525352535253525352535253525352535253525352535677704046676253525352535253525352535253525352535253525352535253525352535253525352535253525352535253525352535445403134555253525352535253525352535253525352535253525352535253525352535253525352535253525352535253525352535253544540111011101110111011145552535253525352535
// 098:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404667625352535253524342535253525356777040404040404040404040404040404040404040404040404040404040404040404040404040466762535253525354454021202120212455525352535253567770404
// 099:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040466762535253525352535253567770404040404040404040404040404040404040404040404040404040404040404040404040404040404046676253525352535445403134555253525352535677704040404
// 100:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404667625352535253524342535253525356777040404040404
// 101:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040466762535253525352535253567770404040404040404
// 102:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 103:040404040404040465752636263626362636263664740404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040465752636263626362636263664740404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 104:040404040404657525352535253527372535253525356474040404040404040404040404040404040404040404040404040404040404040404040404040404040404657525352535253527372535253525356474040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 105:040404046575263626362535475700104656253526362636647404040404040404040404040404040404040404040404040404040404040404040404040465752636263626362535475700104656253526362636263664740404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 106:040465752535253525354757011101110111465625352535253564740404040404040404040404040404040404040404040404040404040404040404657525352535253527374757011101110111465627372535253525356474040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 107:263626362636253547570212021202120212021246562535263626362636263626362636263626366474040404040404657526362636263626362636263626362535475700100212021202120212021200104656253526362636263626362636263664740404040404040404040465752636263626362636263626362636263626362636263626362636263626362636263626362636263626362636263626362636263626362636263626362636263626362636263626362636263626362636263626362636263626362636263626362636263626362636263626362636263626362636263626362636263626362636
// 108:273727372737475701110111011101110111011101114656273727372737273727372737253525352535647404046575253525352535273727372737273727374757011101110111011101110111011101110111465627372737273727372535253525356474040404040404657525352535253527372737273727372737273727372737273727372737273727372737273727372737273727372737273727372737273727372737273727372737273727372737273727372737273727372737273727372737273727372737273727372737273727372737273727372737273727372737273727372737273727372737
// 109:001000100010021202120212021202120212021202120212001000100010001000100010465625352636263626362636263625354757001000100010001000100212021245552434243424342434243444540212021200100010001000104656253526362636647404046575263626362535475700100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010
// 110:011101110111011101110313031303130313031301110111011101110111011101110111011146562737273727372737273747570111011101110111011101110111455525352535253525352535253525354454011101110111011101110111465625352535253564752535253525354757011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111
// 111:021202120212021245552434243424342434243444540212021202120212021202120212021202120010001000100010001002120212021202120212021202124555253525352535677704046676253525352535445402120212021202120212021246562535263626362636253547570212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212
// 112:031303130313455525352535253525352535253525354454031303130313031303130313011101110111011101110111011101110111031303130313031345552535253525356777040404040404667625352535253544540313031303130111011101114656273727372737475701110111011103130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313
// 113:243424342434253525352535677704046676253525352535243424342434243424342434445402120212021202120212021202124555243424342434243425352535253567770404040404040404040466762535253525352434243424344454021202120212001000100010021202120212455524342434243424342434243424342434243424342434243424342434243424342434243424342434243424342434243424342434243424342434243424342434243424342434243424342434243424342434243424342434243424342434243424342434243424342434243424342434243424342434243424342434
// 114:253525352535253525356777040404040404667625352535253525352535253525352535253544540111011101110111011145552535253525352535253525352535677704040404040404040404040404046676253525352535253525352535445403130111011101110111011103134555253525352535253525352535253525352535253525352535253525352535253525352535253525352535253525352535253525352535253525352535253525352535253525352535253525352535253525352535253525352535253525352535253525352535253525352535253525352535253525352535253525352535
// 115:040404040404040404040404040404040404040404040404040404040404040466762535253525354454021202120212455525352535253567770404040404040404040404040404040404040404040404040404040404040404667625352535253524344454021202120212455524342535253525356777040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 116:040404040404040404040404040404040404040404040404040404040404040404046676253525352535445403134555253525352535677704040404040404040404040404040404040404040404040404040404040404040404040466762535253525352535445403134555253525352535253567770404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 117:040404040404040404040404040404040404040404040404040404040404040404040404667625352535253524342535253525356777040404040404040404040404040404040404040404040404040404040404040404040404040404040404667625352535253524342535253525356777040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 118:040404040404040404040404040404040404040404040404040404040404040404040404040466762535253525352535253567770404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040466762535253525352535253567770404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 119:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 120:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 121:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 122:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 123:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 124:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 125:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 126:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 127:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 128:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 129:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 130:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 131:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 132:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 133:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 134:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 135:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// </MAP>

// <WAVES>
// 000:01358acefeca853101368acefeca8531
// 001:001235789aabcdeffffeda9876332110
// 002:0123456789abcdea0123456789abcd53
// 003:0123456789abcdef0123456789abcdef
// 005:0123456789abcdedecab997654421100
// 006:9744439acccefff4976ba91c55876614
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
// 004:068006500600f600f600f600060006000600060006000600060016001600260036004600460056006600760086009600a600b600c600d600e600f600580000000300
// 005:080008400850087008c0080018002800380048004800580058006800780078008800880098009800a800a800b800c800c800e800e800e800e800f800309000000500
// 006:8b006b404b702b000b400b700b000b400b700b400b700bb00b400b700bb00b701bb02be02b704bb05be07b708bb08be09b709bb0abe0cb70ebb0fbe0460000000000
// 048:04002100410f610f910ee10ef10df10df10df10df10df10df10df10df10df10df10df10df10df10df10df10df10df10df10df10df10df10df10df10da02000000000
// 049:64008400b400e400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400604000000000
// 050:1400640fa40ef40df40cf40bf409f408f408f408f409f409f408f408f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400b00000000000
// 051:0400440074009400a400b400d400e400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400300000000000
// 052:040046006600760fa60fc60ee60ee60ee60df60df60cf60cf60cf60bf60bf60bf60df60df60df60df60df60cf60cf60cf60cf60cf60cf60cf60cf60c300000000000
// 053:040045008500a50fe50ff50ef50ef50ef50df50df50cf50cf50cf50bf50bf50bf50df50df50df50df50df50cf50cf50cf50cf50cf50cf50cf50cf50c105000000000
// 054:64008400b400e400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400604000030000
// 055:f400f400f400040f450f950ef50ef50ef50df50df50cf50cf50cf50bf50bf50bf50df50df50df50df50df50cf50cf50cf50cf50cf50cf50cf50cf50c402000000000
// 056:06000100010001000100110011001100110021002100310051006100610071007100810081009100a100a100b100c100c100d100e100f100f100f100300000000000
// 057:27005700670077008700870087009700a700a700b700b700b700b700b700c700d700d700e700f700f700f700f700f700f700f700f700f700f700f700400000000000
// 058:d800a8009800680058004800480048004800480048004800480048004800480048004800480048004800480048004800480048004800480048004800400000000000
// 059:720032000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200200000000000
// 060:37000700070037005700770087009700a700a700b701b702b701c700c70fc70ef70ff700f700f700f700f700f700f700f700f700f700f700f700f700400000f10098
// 061:01001100210021003100410041005100610061007100810081009100a100b100b100c100c100d100d100c100c100c100c100c100c100c100c100c100200000000000
// 062:0100110021003100410051006100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100207000000000
// 063:080008000800080008000800080008000800180018002800380038004800480048004800480048005800580058006800680068006800780078007800404000000000
// </SFX>

// <PATTERNS>
// 000:900895100000000000000000400895100000000000000000800895100000000000000000400895100000000000000000900895100000000000000000000000900893000000000000022600000000000000000000000000000000000000000000100000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 001:4fa9a90000000000000000000000000000000d91000000000a79a10000000000000741000000000000000521000000000008a10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004f89a90000000000000000000d61000000000a51000000000941000000000631000000000008a1000000000000000000
// 002:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004008b5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 003:0008a10000000000000000000000000000000000000000006ff9a90000000000000000000000000dd1000cc1000aa1000999a10000000881000000000000000771000000000661000000000000000551000000000000000441000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006ff9a90000000000000000000000000dd1000000000aa1000000000661000000008999a9000000000000000000
// 004:0008a10000000000000000000000000000000000000000000008a1000000000000000000000000000000000000000000baf9a700000000000000000009d10000000000000007a100000000000000069100000000000000058100000000000000047100000000036100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b9f9a90008a100000000000007d10000000006a100000000058100000000035100000000000000000000
// 005:9f89a50000000000000000000d71000000000b61000000000a51000000000941000000000731000000000000000000009f89a90000000d71000000000a61000000000941000000000631000000000000000000000000000000000000000000000008a10008a1000000000000bf89a70000000d71000000000b6100000000095100000000074100000000063100000000000000000000000000000000000000000000052100000000042100001000031100000000021100000000010100000000
// 006:9008b30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004008b50000000000000000000000000000000000000000000000000000000000000000000000000000000aa100000000087100000000055100000000044100000000022100000000
// 007:4ff9a70000000000000000000dd1000000000bb1000000000991000000000771000000000661000000000551000000000000000000000000000000000000000000000000000000008ff9a90000000aa1006ff9a90000000000000000000dd1000000000cc1000000000aa100000000099100000000088100000000066100000000055100000000000000000000000000000000000000000000000000000000000000000000000000044100000000033100000000022100000000011100000000
// 008:d8f9a700000000000000000007d10000000006b10000000005910000000004710000000003510000000000000000000000000000000000000000000000000000000000000000000000000048f9a900000000000000000000000007d1000000008ff9a90000000000000000000dd9b10000000bb1000000000aa100000000099100000000088100000000077100000000066100000000055100000000044100000000000000000000000000000000033100000000022100000000011100000000
// 009:4ff9c90000004008c9b008c90008c11008c19008c90000001008c10000000000004008cb000000b008c99008c90000004008c90000004008c9b008c90000001008c19008c90000001008c10000000000004008cb000000f008c90000000000004008c90000004008c9b008c90000001008c19008c90000001008c1000000000000d008c90008c16008c90000000000004008c90000004008c9b008c90000001008c19008c90000001008c10000004008cb0008c1000000000000000000000000
// 010:4008d50000001008c14008d5100811000000000000000000000000000000000000b008e5b008e5b008e5b008e50000004008d50000001008c14008d5000000000000000000000000400805000000000000b008e5b008e5b008e5b008e50000004008d50000001008c14008d5100811000000000000000000000000000000000000b008e5b008e5b008e5b008e50000004008d50000001008c14008d5100811000000000000000000000000000000000000b008e5b008e5b008e5b008e5000000
// 011:0ff9c10000000008c1f008c90008c11008c1d008c90000001008c10000000000000008c1f008c90008c10008c10000001008c10000000008c1f008c90000001008c1d008c90000001008c10000000000000008c16008cb0008c1b008c90000001008c10000000008c1f008c90000001008c1d008c90000001008c10000000000000008c1b008c90008c18008c90000001008c10000000008c1f008c90000001008c1d008c90000001008c10000000000006008cb000000000000000000000000
// 012:4ff90500000000000000000040081d00000000000000000040080500000000000000000040081d00000000000000000040080500000000000000000040081d00000000000000000040080500000000000000000040081d00000000000000000040080500000000000000000040081d00000000000000000040080500000000000000000040081d00000000000000000040080500000000000000000040081d000000000000000000400805000000000000000000b008cb000000400805400805
// 013:8f89a90000000b61000a51000941000521000411000000000201000000000101000000000000000000000000000000001000000000000000000000008f89a90000000a61000000009008a9000000000000000000b008a9000000000000000000ef89a90000000d71000000000a6100000000d008a9e008a9bf89a90d71000000000a61000000000851000000000641000000000431000000000211001000000000000000000000004f89a90000000d51000000006ff8a90000000a4100000000
// 014:4008d50000001008c14008d5100811000000000000000000000000000000000000b008e5b008e5b008e5b008e50000004008d50000001008c14008d50000000000000000000000001008010000004008d50000006008d50000008008d5000000b008e50000001008c1b008d5000000100000000000b008d50000000000000000006008e76008e76008e76008e7000000b008d50000001008c1b008d5100811000000000000000000000000000000b008d5000000b008d50000009008d5000000
// 015:40080500000000000000000040081d00000000000000000040080500000000000000000040081d00000000000000000040080500000000000000000040081d00000000000000000040080500000000000000000040081d00000000000000000040080500000000000000000040081d00000000000000000040080500000000000000000040081d00000000000000000040080500000000000000000040081d00000000000000000040080500000000000000000040081d00000040081d40081d
// 016:7f89a90000000b61000a51000941000521006008a97008a94f89a90d71000000000a61000000000851000000000641000000000431000000000211000008a10000001008d1000000ef99a70000000a61000000009f99a70000000a6100000000bf89a70000000d71000000000a61000000000008a19008a78f89a70d71000000000a61000000000851000000000641000000000431000000000211000000000000000000000000001008d10000000000000000000ff8a1000000000000000000
// 017:c008d50000001008c1c008d51008110000000000000000000000000000000000009008e59008e59008e59008e5000000e008d50000001008c1e008d50000000000000000000000001008010000009008d50000009008d5000000b008d5000000b008e50000001008c14008d50000001000000000004008d5000000000000000000b008e5b008e5b008e5b008e50000004008d50000001008c14008d5100811000000000000000000000000000000b008d51008d1b008d5d008d5b008d5000000
// 018:4239cb6008cbb008cbb008c94008cb6008cbb008cbb008c94008cb6008cbb008cbb008c94008cb6008cbb008cbb008c94239cb6008cbb008cbb008c94008cb6008cbb008cbb008c94008cb6008cbb008cbb008c94008cb6008cbb008cbb008c94239cb6008cbb008cbb008c94008cb6008cbb008cbb008c94008cb6008cbb008cbb008c94008cb6008cbb008cbb008c94239cb6008cbb008cbb008c94008cb6008cbb008cbb008c94008cb6008cbb008cbb008c94008cb6008cbb008cbb008c9
// 019:8f89a90000000b61000a51000941000521000411000000000201000000000101000000000000000000000000000000001000000000000000000000008f89a90000000a61000000009008a9000000000000000000b008a9000000000000000000ef89a90000000d71000000000a6100000000d008a9e008a9bf89a90d71000000000a61000000000851000000000641000000000431000000000211001000000000000000000000004f89a90000000d51000000006ff8a90000000a4100000000
// 020:4ff9056239cbb008cbb008c94ff91d6239cbb008cbb008c94ff9056239cbb008cbb008c94ff91d6239cbb008cbb008c94ff9056239cbb008cbb008c94ff91d6239cbb008cbb008c94ff9056239cbb008cbb008c94ff91d6239cbb008cbb008c94ff9056239cbb008cbb008c94ff91d6239cbb008cbb008c94ff9056239cbb008cbb008c94ff91d6239cbb008cbb008c94ff9056239cbb008cbb008c94ff91d6239cbb008cbb008c94ff9056239cbb008cbb008c94ff91d6239cbb008cbb008c9
// 021:b889a7000000066100055100044100022100011100000000011100000000011100000000000000000000000000000000100000000000000000000000b889a70000000661000000004008a90000000000000000006008a90000000000000000009889a90000000771000000000661000000008008a96008a9e889a7077100000000066100000000000000d008a7b449a74008a9033100000000000000e008a7000000000000000000100000000000000000000000000000000000000000000000
// 022:4889a9000000076100055100044100022100000000000000c559a70000000000000661007008a90551000000000441009008a90331000000000111000008a10000001008d1000000b999a70000000661000000006999a70000000661000000008889a70000000771000000000661000000000008a16008a74008a70000000000000000000000000000000000000000000000000431000000000211000000000000000000000000001008d10000000000000000000ff8a1000000000000020300
// 023:4008c9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d008c90000000000000000000000000000000000000000000000000000000000000000000ff1000000000ee1000000000dd1000000000cc1000000000bb1000000000aa100000000099100008000088100000000077100000000066100000000055100000000044100000000033100000000022100000000011100000000000000000000000000000000000000000000
// 024:0000006008c90000000000000000000000000000000000008008c90000000000000000000000000000000000000000000000004008cb0000000000000000000000000000000000000000000000000000000000000ff1000000000ee1000000000dd1000000000cc1000000000bb1000000000aa100000000099100008000088100000000077100000000066100000000055100000000044100000000033100000000022100000000011100000000000000000000000000000000000000000000
// 025:000000000000b008c9000000000000000000000000000000000000b008c90000000000000000000000000000000000000000000000008008cb0000000000000000000000000000000000000000000000000000000ff1000000000ee1000000000dd1000000000cc1000000000bb1000000000aa100000000099100008000088100000000077100000000066100000000055100000000044100000000033100000000022100000000011100000000000000000000000000000000000000000000
// 026:000000000000000000000000000000000000000000000000000000000000f008c90000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009ff9d70000000000001000009dd9d70000000000001000009aa9d70000000000001000009889d70000000000001000009559d7000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 027:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010089100000000000095a99b66999bf7899968799bf96999ba59990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008910000001008910000000000008a599b49699bb8799947899bb6999985a999
// 028:000000000000d0089910089190089900000000000040089b10089140089b10089140089bf00899000000d00899000000b00899000000000000800899000891000000100891000000000000b0089b80089b40089b80089b40089bb00899000000000000000000600899100891f00897000000000000900899100891900899100891900899600899000000f00897000000400899400899400899100891000891400899400899400899100891000000000000000000000000000000000000000000
// 029:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100891000000000000b5a99b86999b47899b88799b49699bba5999000000000000000000000000000000000000000000d00899100891b00899100891900899800899000000600899000000400899000000000000800899000000000000400899000891000000000000000000000000000000000000000000000000
// 030:40080700000040081f00000040081f000000400807b0085940081f40081fb0084300000040081fb0084340080700000040080740081f40081f00000040081f00000040081fb0084300000040081fb0084300000040080700000040081f40081f40080700000040081f00000040081f000000400807b0085940081f40081fb0084300000040081fb00843400807000000b00843400807b0084300000040081f00000040081fb0084300000000000000000000000000000000000040081f40081f
// 031:400887000881100881000000b00885000000100881e00885100881e00885b00885000000e00885000000f00885000000400887100891400887100881b00885000000100881e00885100881e00885b00885000000a00885000000b00885000000400887000881100881000000b00885000000100881e00885100881e00885b00885000000e00885000000f00885000000400887100881400887100881e00885400887100881400887100881400887b00885000000e00885000000f00885000000
// 032:433997000881100881000000b00895000000100881e00895100881e00895b00895000000e00895000000f008950000004aa997100891400897000000b00895000000100881e00895100881e00895b00895000000e00895000000f008950000004ff997000881100881000000b00895000000100881e00895100881e00895b00895000000e00895000000f008950000008008991008a1800899100891600899700899100891800899000881000881000881000000000881000000000881000000
// 033:0000000000009008ad0000001008a10000000000000000000000000000000008a19008ad0008a11008a10000000008a10000000000009008ad0000001008a10000000000000000000000000000000000009008ad0008a11008a1000000000000899999000881100881000000e00897000000100881600899100881600899e0089700000060089900000070089900000040089b10089140089b100891e00899f0089910089140089b0000000000006008ad0000006008ad0000001008a1000000
// 034:400887000881100881000000b00885000000100881e00885100881e00885b00885000000e00885000000f00885000000400887100891400887000000b00885000000100881e00885100881e00885b00885000000a00885000000b00885000000400887000881100881000000b00885000000100881e00885100881e00885b00885000000e00885000000f00885000000b00899400887b00899400887900899a00899400887b00899000000000000000000000000e00885000000f00885000000
// 035:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000666979000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000600879000000000000000000000000000000600879000000000000600859600859000000600879000000000000
// 036:000000000000000000000000600859000000000000600859000000600859000000000000600859600859000000000000000000000000600859000000600859000851000000000000600859000000600859000000000000600859000000000000600859600859000000000000600859000000000000600859000000000000000000000000600859000000600859000000000000600859600859000851600859600859000000600859600859000851b66995000000e66995000000f66995000000
// 037:40080700000040081f00000040081f000000400807b0085940081f40081fb0084300000040081fb0084340080700000040080740081f40081f00000040081f00000040081fb0084300000040081fb0084300000040080700000040081f40081f40080700000040081f00000040081f000000400807b0085940081f40081fb0084300000040081fb00843400807000000b00843400807b0084300000040081f00000040081fb0084340081f40081fb0084300000040081fb0084340080740081f
// 038:000000000000800899100891400899000000000000b00899100891b00899100891b008998008990000004008990000006008990000000000009008990008910000001008910000000000009939991008919939999008990008911008910000001008910000006ff999100891f00897000000000000900899100891900899100891900899600899000000f00897000000400899000000000000800899000891000000100891000000000000839999100891800899800899000891400899000000
// 039:100891000000d0089910089190089900000000000040089b10089140089b10089140089bf00899000000d00899000000b008990000000000008008990008910000001008910000000000008939991008918008998008990008916008990000001008910000006ff999100891f00897000000000000900899100891900899100891900899600899000000f00897000000400899100891400899100891000891400899100891400899100891000000000000000000000000000000000000000000
// 040:069100000000b0089910089180089900000000000040089b10089140089b10089140089bb00899000000800899000000900899000000000000d00899000891000000100891000000000000b93999100891b00899b00899000000100891000000069100000000900899100891600899000000000000f00899100891f00899100891f00899d00899000000b00899000000800899000000000000b00899000891000000100891000000000000b39999100891b00899b00899000000100891000000
// 041:06910000000040089b100891d0089900000000000092499b10089190089b10089180089b60089b00000046999b000000f00899000000000000b00899000891000000100891000000000000b93999100891b00899b00899000000100891000000069100000000900899100891600899000000000000d9a999100891b00899100891900899800899000000600899000000400899000000b00897000891000000800897000891400897000000000000000000000000000000000000000000000000
// 042:400807000000e0082900000040081f400807000000b0083900000000000040081fb0084300000040081f60084300000040081f400807e0082900000040081f400807000000b0083900000000000040081fe0082900000040081fe00829000000400807000000e0082900000040081f400807000000b0083900000000000040081fb0084300000040081f60084300000040080700000000000040080700000040081fb0083900000000000000000000000000000000000040081fe00829e00829
// </PATTERNS>

// <TRACKS>
// 000:100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ec02df
// 001:2c04416c1842ac2c43ec3314194314ec36551947550000000000000000000000000000000000000000000000000000009b0000
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
// 091:000000000000000000000000000000000003222222222222222222222222222222222222222222220000000000000000000000000000000000000000000000000000000000000000000000000000000022222222222222222222222222222222222222222222100000000000000000000000000000000000
// 092:000000000000000000000000000000000003222222222222222222222222222222222222222222220888888888888888888888888888888888888888888888888888888888888888888888888888888022222222222222222222222222222222222222222222100000000000000000000000000000000000
// 093:000000000000000000000000000000000003222222222222222222222222222222222222222222220888888888888888888888888888888888888888888888888888888888888888888888888888888022222222222222222222222222222222222222222222100000000000000000000000000000000000
// 094:000000000000000000000000000000000003222222222222222222222222222222222222222222220888888888888888888888888888888888888888888888888888888888888888888888888888888022222222222222222222222222222222222222222222100000000000000000000000000000000000
// 095:000000000000000000000000000000000003222222222222222222222222222222222222222222220888888888888888888888888888888888888888888888888888888888888888888888888888888022222222222222222222222222222222222222222222100000000000000000000000000000000000
// 096:000000000000000000000000000000000003222222222222222222222222222222222222222222220888888888888888888888888888888888888888888888888888888888888888888888888888888022222222222222222222222222222222222222222222100000000000000000000000000000000000
// 097:000000000000000000000000000000000003222222222222222222222222222222222222222222220888888888888888888888888888888888888888888888888888888888888888888888888888888022222222222222222222222222222222222222222222100000000000000000000000000000000000
// 098:000000000000000000000000000000000003222222222222222222222222222222222222222222220888888888888888888888888883333833338833388333388333388888888888888888888888888022222222222222222222222222222222222222222222100000000000000000000000000000000000
// 099:000000000000000000000000000000000003222222222222222222222222222222222222222222220888888888888888888888888833388883388338838338838833888888888888888888888888888022222222222222222222222222222222222222222222100000000000000000000000000000000000
// 100:000000000000000000000000000000000003222222222222222222222222222222222222222222220888888888888888888888888883338883388338838338838833888888888888888888888888888022222222222222222222222222222222222222222222100000000000000000000000000000000000
// 101:000000000000000000000000000000000003222222222222222222222222222222222222222222220888888888888888888888888888333883388333338333388833888888888888888888888888888022222222222222222222222222222222222222222222100000000000000000000000000000000000
// 102:000000000000000000000000000000000003222222222222222222222222222222222222222222220888888888888888888888888833338883388338838338838833888888888888888888888888888022222222222222222222222222222222222222222222100000000000000000000000000000000000
// 103:000000000000000000000000000000000003222222222222222222222222222222222222222222220888888888888888888888888888888888888888888888888888888888888888888888888888888022222222222222222222222222222222222222222222100000000000000000000000000000000000
// 104:000000000000000000000000000000000003222222222222222222222222222222222222222222220888888888888888888888888888888888888888888888888888888888888888888888888888888022222222222222222222222222222222222222222222100000000000000000000000000000000000
// 105:000000000000000000000000000000000003222222222222222222222222222222222222222222220888888888888888888888888888888888888888888888888888888888888888888888888888888022222222222222222222222222222222222222222222100000000000000000000000000000000000
// 106:000000000000000000000000000000000003222222222222222222222222222222222222222222220888888888888888888888888888888888888888888888888888888888888888888888888888888022222222222222222222222222222222222222222222100000000000000000000000000000000000
// 107:000000000000000000000000000000000003222222222222222222222222222222222222222222220888888888888888888888888888888888888888888888888888888888888888888888888888888022222222222222222222222222222222222222222222100000000000000000000000000000000000
// 108:000000000000000000000000000000000003222222222222222222222222222222222222222222220888888888888888888888888888888888888888888888888888888888888888888888888888888022222222222222222222222222222222222222222222100000000000000000000000000000000000
// 109:000000000000000000000000000000000003222222222222222222222222222222222222222222220888888888888888888888888888888888888888888888888888888888888888888888888888888022222222222222222222222222222222222222222222100000000000000000000000000000000000
// 110:000000000000000000000000000000000003222222222222222222222222222222222222222222220000000000000000000000000000000000000000000000000000000000000000000000000000000022222222222222222222222222222222222222222222100000000000000000000000000000000000
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

