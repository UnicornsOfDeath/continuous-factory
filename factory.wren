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
var LEVEL=0
var NUM_LEVELS=2
var COLOR_BG=5
var COLOR_KEY=9
var MUSSPLASH=0
var MUSGAME=1
var MUSTITLE=2
var MUSDEATH=3
var MUSWIN=4
var MUSTEMPO=100
var MUSSPD=3
var FPS=60
var MUSBEATTICKS=FPS*60/MUSTEMPO*MUSSPD/6
var SFXNEXT=1
var SFXDOTASK=2
var SFXSPAWN=3
var SFXCOMPLETE=4
var SFXINCOMPLETE=5
var SFXRIGHT=6
var SFXWRONG=7
var SFXTXT=8
var SFXEXPLODE=9
var SFXBORK=10
var RANDOM=Random.new()
var FONTH=5

var UP=0
var DOWN=1
var LEFT=2
var RIGHT=3

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

// JOB

var JOB_SPAWN_TICKS=120

var CONVEYOR_TICKS=60
var JOB_TICKS=240

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

class TitleState is SkipState {
	construct new() {
		super(40)
    }

	reset() {
		super.reset()
		TIC.music(MUSTITLE,-1,-1,false)
    }

	finish() {
		TIC.sfx(SFXNEXT)
        TIC.music() // stop
    }

    update(){
        super.update()
    }

    draw() {
        super.draw()
        TIC.cls(COLOR_BG)
        TIC.print("Press Z or X to Start",30,100,2+(tt/20)%2)
        var cf=ChunkyFont.new(30,20)
        cf.s("^12Continuous\n^5eFactory")
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
    construct new(sprite){
        super(0,0,10,10,sprite,1,1,3,8,9)
    }
}

class Toolbar {

    construct new() {
        _buttons={
            CONV_R: ToolbarButton.new(18),
            CONV_L: ToolbarButton.new(19),
            CONV_U: ToolbarButton.new(20),
            CONV_D: ToolbarButton.new(21),
        }

        _selection=null
    }

    clicked() {
        return _buttons.values.any {|button| button.clicked }
    }

    buttonClicked() {
        return _selection
    }

    update(){
        var ypos=16
        for (button in _buttons) {
            button.value.x=(MAP_W-2)*8+2
            button.value.y=ypos
            button.value.update()
            if(button.value.clicked) {
                _selection=button.key
            }
            ypos=ypos+12
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
        _map=GameMap.new(LEVEL, Fn.new { failState() })
        _buildPhase=true
        _mouse=TIC.mouse()
        _toolbar=Toolbar.new()
        _startbtn=LabelButton.new(50,1,50,9,"START",3,8,9)
        _resetbtn=LabelButton.new(120,1,50,9,"RESET",3,8,9)
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
        _buildPhase=true
		TIC.music(MUSGAME,-1,-1,true)
		_startbtn=LabelButton.new(50,1,50,9,"START",3,8,9)
		_resetbtn=LabelButton.new(120,1,50,9,"RESET",3,8,9)
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
                _buildPhase=false
                tt=0
                _map.start()
            }else if(_toolbar.clicked()) {
                // NO-OP
            }else if(_resetbtn.clicked){
                reset()
                _map.resetConveyorBelts()
            }else{
                _mouseX=_mouse[0]
                _mouseY=_mouse[1]
                _mouseClick=_mouse[2]
                _mouseRightClick=_mouse[4]
                if(!_mouseClick&&mousePrev[2]==true) {
                    var tileX=(_mouseX/16).floor
                    var tileY=(_mouseY/16).floor

                    if(_toolbar.buttonClicked()==CONV_U) {
                        _map.addConveyorBelt(tileX, tileY, UP, CONV_U)
                    } else if(_toolbar.buttonClicked()==CONV_D) {
                        _map.addConveyorBelt(tileX, tileY, DOWN, CONV_D)
                    } else if(_toolbar.buttonClicked()==CONV_L) {
                        _map.addConveyorBelt(tileX, tileY, LEFT, CONV_L)
                    } else if(_toolbar.buttonClicked()==CONV_R) {
                        _map.addConveyorBelt(tileX, tileY, RIGHT, CONV_R)
                    }
                    TIC.sfx(SFXNEXT)
                }

                if(!_mouseRightClick&&mousePrev[4]==true) {
                    var tileX=(_mouseX/16).floor
                    var tileY=(_mouseY/16).floor

                    _map.removeConveyorBelt(tileX,tileY)
                }
            }
        }

        if (_failed){
            if (_deathticks>0) {
                _deathticks=_deathticks-1
            }
        }

        _map.update()
    }

    next() {
        // TODO: livesticks
        if (_map!=null&&_map.jobsDone==_map.jobsCount) {
            finish()
            winstate.reset()
            return winstate
        }
        if (_failed && _deathticks==1) {
            finish()
            nextstate.reset()
            return nextstate
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
        }
        _tt=(tt/60).floor
        TIC.rect(0,0,WIDTH,11,_buildPhase?13:9)
        TIC.print("Level:%(LEVEL+1)",2,2,0,false,1)
        if(_buildPhase){
            TIC.print("Build Phase",WIDTH-40,2,0,false,1,true)
            _startbtn.draw()
            _resetbtn.draw()
        }else{
            TIC.print("Time:%(_tt)",WIDTH-70,2,0,false,1,true)
            TIC.print("Jobs:%(_map.jobsDone)/%(_map.jobsCount)",WIDTH-40,2,0,false,1,true)
        }
        _toolbar.draw()
    }
}

class DeathState is SkipState {
	construct new() {
		super(60)
    }

    reset() {
        super.reset()
        TIC.music(MUSDEATH,-1,-1,false)
    }

	finish() {
        return
    }

    update() {
        super.update()
    }

    next() {
        finish()
        nextstate.reset()
        return nextstate
    }

	draw() {
		super.draw()
		//TIC.cls(COLOR_BG)
		//TIC.print("Totalled!", 50, 50, 3)
		//TIC.print("Press any key to restart", 40, 100, 12)
    }
}

class WinState is SkipState {
	construct new() {
		super(300)
    }
    winstate { _winstate }
    winstate=(value) {
        _winstate=value
    }

	reset() {
		super.reset()
		TIC.music(MUSWIN,-1,-1,false)
        LEVEL=LEVEL+1
    }

	finish() {
    }

    next() {
        if (LEVEL==NUM_LEVELS) {
            finish()
            LEVEL=0
            winstate.reset()
            return winstate
        }
		return super()
    }

	draw() {
		super.draw()
		TIC.cls(COLOR_BG)
		TIC.print("Level complete!", 40, 30, 5)
        if (canSkip){
            TIC.print("Press any key to reset", 10, HEIGHT-10, 12)
        }
    }
}

class ConveyorBelt is GameObject {
    
    construct new(x,y,dir) {
        super(x*16,y*16,Rect.new(0,0,16,16))
        _dir=dir
        _ticks=0
    }

    draw() {
        var frame=(_ticks/15).floor%4
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

class GameMap {
    
    construct new(i, killStateFunction) {
        _started=false
        _conveyorBelts=[]
        _jobs=[]
        _killStateFunction=killStateFunction
        for(i in 1..MAP_H) {
            _conveyorBelts.add(List.filled(MAP_W, null))
        }
        _factories=[]
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
            job.ticks=CONVEYOR_TICKS
            _spawnJobs.add(job)
        }
        _jobsCount=_spawnJobs.count
        _jobsDone=0
        for(x in 0..MAP_W/2) {
            for(y in 0..MAP_H/2){
                var tileId=getTileId(x,y)
                if(tileId==IN_TILE){
                    _inTile=InTile.new(x,y,_spawnJobs)
                }else if(tileId==OUT_TILE){
                    _outTile=OutTile.new(x,y)
                }else if(tileId==CONV_R){
                    addConveyorBelt(x,y,RIGHT,tileId)
                }else if(tileId==CONV_L){
                    addConveyorBelt(x,y,LEFT,tileId)
                }else if(tileId==CONV_U){
                    System.print(tileId)
                    addConveyorBelt(x,y,UP,tileId)
                }else if(tileId==CONV_D){
                    addConveyorBelt(x,y,DOWN,tileId)
                }else if(tileId==DISK||tileId==APPLE||tileId==GLASS||tileId==WIN||tileId==LINUX||tileId==HAMMER){
                    _factories.add(Factory.new(x,y,tileId))
                }
            }
        }
    }

    spawnJobs{_spawnJobs}
    jobsCount{_jobsCount}
    jobsDone{_jobsDone}

    start() {
        _started=true
    }

    stop() {
        _started=false
    }

    addConveyorBelt(x,y,dir,tileId) {
        _conveyorBelts[x][y]=ConveyorBelt.new(x,y,dir)
        TIC.mset(x,y,tileId)
    }

    removeConveyorBelt(x,y) {
        _conveyorBelts[x][y]=null
        TIC.mset(x,y,0)
    }

    resetConveyorBelts() {
        _conveyorBelts.each {|conveyorBeltColumn|
            conveyorBeltColumn.each {|conveyorBelt|
                if(conveyorBelt!=null) {
                    var tileX=(conveyorBelt.x/16).floor
                    var tileY=(conveyorBelt.y/16).floor
                    removeConveyorBelt(tileX, tileY)
                }
            }
        }
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
         var ystart=(LEVEL/8).floor
        return TIC.mget(xstart+x,ystart+y)
    }

    update(){
        _conveyorBelts.each {|conveyorBeltColumn|
            conveyorBeltColumn.each {|conveyorBelt|
                if(conveyorBelt!=null) conveyorBelt.update()
            }
        }
        
        if(!_started){
            return
        }
        var xstart=(LEVEL%8)*MAP_W
        var ystart=(LEVEL/8).floor

        _factories.each {|factory|
            factory.update()
        }

        var jobMoved=false

        _jobs.each { |job|
            job.update()
            var x = job.x
            var y = job.y
            var tileId=TIC.mget(xstart+x,ystart+y)
            if(job.canMove){
                var stayHere=false
                if(tileId==IN_TILE){
                    job.moveRight()
                    job.ticks=CONVEYOR_TICKS
                }else if(tileId==OUT_TILE){
                    _jobs.remove(job)
                    if (job.isComplete){
                        TIC.sfx(SFXCOMPLETE)
                        _jobsDone=_jobsDone+1
                    }else{
                        TIC.sfx(SFXINCOMPLETE)
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
                        TIC.sfx(SFXDOTASK)
                        // We still need to stay at this factory, don't move yet
                        stayHere=true
                    }else{
                        job.ticks=CONVEYOR_TICKS
                    }
                }

                if (!stayHere&&hasNoJobAt(job.x+job.dx,job.y+job.dy)) {
                    job.move()
                }

                jobMoved=true
            }

            if (tileId != IN_TILE && tileId != OUT_TILE && tileId != CONV_R && tileId != CONV_L&& tileId != CONV_D && tileId != CONV_U && tileId != DISK && tileId != APPLE && tileId != GLASS && tileId != WIN && tileId != LINUX && tileId != HAMMER) {
              _killStateFunction.call()
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
        _factories.each {|factory|
            factory.draw()
        }

         _jobs.each {|job|
            job.draw()
        }
    }
}

class Game is TIC{

	construct new(){
        var splashState = SplashState.new()
        var titleState = TitleState.new()
        var mainState = MainState.new()
        var deathState = DeathState.new()
        var winState = WinState.new()
        splashState.nextstate = titleState
        titleState.nextstate = mainState
        mainState.nextstate = deathState
        mainState.winstate = winState
        deathState.nextstate = mainState
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

class Job is GameObject {
    construct new(x,y,dx,dy,tasks) {
        super(x,y,Rect.new(0,0,16,16))
        _dx=dx
        _dy=dy
        _tasks=tasks
        _ticks=0
    }
    dx{_dx}
    dy{_dy}

    canMove { _ticks<=0 }
    ticks=(value){_ticks=value}
    isComplete{_tasks.count==0}

    draw() {
        TIC.spr(352,x*16-4,y*16-4,COLOR_KEY,1,0,0,3,3)
        var drawy=y*16
        for (task in _tasks) {
            TIC.spr(task.key,x*16,drawy,COLOR_KEY)
            if(task.value>1) {
                TIC.print("x%(task.value)",x*16+9,drawy+2,0,false,1,true)
            }
            drawy=drawy+8
        }
    }

    update() {
        _ticks=_ticks-1
    }

    // Actually move this job
    move(){
        x=x+_dx
        y=y+_dy
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
// 016:00000000000000000f0f00f00f0ff0f00f0f0ff00f0f00f00f0f00f000000000
// 017:0000000000000000090809999098089090980890909808900908889000000000
// 018:9999999999991999999911999111111991111119999911999999199999999999
// 019:9999999999919999991199999111111991111119991199999991999999999999
// 020:9999999999911999991111999111111999911999999119999991199999999999
// 021:9999999999911999999119999991199991111119991111999991199999999999
// 032:9000009905225509052255090555550905333509053335099000009999999999
// 033:9990809990080099088088090ffff0990dddd099077777090aaaaa0990505099
// 034:9000099901221099023e209902ee209901221f099000cdf099990c0999999099
// 048:990000999007800900778809907ef80900eeff0990e00f090009900999999999
// 049:900000990000000903303309031013090fffff0903ddd3090333330999999999
// 050:99999999990099999020999902100000011cccc0901000000111099990009999
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
// 016:4594594545945994459455994599455545599444945599999945555599944444
// 017:5495495449954954995549545554995444499554999955495555549944444999
// 018:4945945549459945494559944994559945994555455994449455999999444444
// 019:5549549454995494499554949955499455549954444995549999554944444499
// 020:9459459994594559945994559455994499455999499455554599444444499999
// 021:9954954995549549554995494499554999955499555549944444995499999444
// 022:021eeeee021eeeee021eeeee021eeeee021eeeee021333330222222200000000
// 023:eeee3210eeee3210eeee3210eeee3210eeee3210333332102222220900000099
// 032:9000000001111111011111110000000002222222022222220111111100000000
// 033:0000000911111110111111100000000022222220222222201111111000000000
// 034:9000000001111111022222220111111100000000022222220222222201111111
// 035:0000000911111110222222201111111000000000222222202222222011111110
// 036:9000000001111111022222220222222201111111000000000222222202222222
// 037:0000000911111110222222202222222011111110000000002222222022222220
// 038:9000000001111111000000000222222202222222011111110000000002222222
// 039:0000000911111110000000002222222022222220111111100000000022222220
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
// 112:99cfffff99cfffff99cfffff99cfffff99cfffff99cfffff99cfffff99cfffff
// 113:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
// 114:fffff099fffff099fffff099fffff099fffff099fffff099fffff099fffff099
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
// 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001404140414040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 001:000100000002000000000000000000000000000000000000000000000000000121210221215100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001400140014001400051505150515040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 002:000000000000120000000000000000000000000000000000000000000000000000000000005100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000051505150515051505150504140414040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 003:000000000000000000000000000000000000000000000000000000000000000051311231313100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010001000100010001000101404140405150414040404040404040404040404040404040404040404040404040404040404040404040404040400100010001000100010001000100404040404040404
// 004:0000000000003c3c11000000000000000000000000000000000000000000000051000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111011101110111011101111505150515050515040404040404040404040404040404040404040404040404040404040404040404040404040401110111011101110111011101110404040404040404
// 005:263626362636263626362636263626362636263626362636263626362636000021212121212111000000000000000000000000000000000000000000263626362636263626362636263626362636263626362636263626362636000000000000000000000000000000000000000000000000000000000000001000100010001000100010001000100010001000100010001000100010000000000010001000102030203002120212203020300010001014041404140404040404040404040404040404040404040404040404040404040404001000100010001020302030203020302030203020300010001000100010
// 006:273727372737273727372737273727372737273727372737273727372737000000000000000000000000000000000000000000000000000000000000273727372737273727372737273727372737273727372737273727372737000000000000000000000000000000000000000000000000000000000000011101110111011101110111011101110111011101110111011101110111000000000111011101112131213103130313213121310111011115051505150404040404040404040404040404040404040404040404040404040404011101110111011121312131213103132131213121310111011101110111
// 007:001000100010001000100010001000100010001000100010001000100010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000100010001000100010001000100010001000100010001000100010203020302030203020302030203020302030203020302030203020302030001000102030203002120212021204140414021202122030203000100010001000100010001004040404040404040404040404040010001000100010203020302030203020302030455524344454203020302030203020302030
// 008:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000213121312131213121312131213121312131213121312131213121312131011101112131213103130313031305150515031303132131213101110111011101110111011104040404040404040404040404040111011101110111213121312131213121314555140414041404445421312131213121312131
// 009:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000203020302030203020302030203020302030203020302030203020302030021202120212021214041404140404140414041404140212021202120212021202122030203000100010040404040404001000102030203002120212203020302030203020304656150515051505475720302030203020302030
// 010:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000213121312131213121312131213121312131213121312131213121312131031303130313031315051505150505150504141505150313031303130313031303132131213101110111040404040404011101112131213103130313213121312131213121312131465627374757213121312131213121312131
// 011:243424342434243424342434243424342434243424342434243424342434000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000021202120212021202120212021202120212021202120212021202120212000000000000000000000000000014041405151414041404140414041404140000000212021220302030001000100010203020300212021200000000021202120212021220302030203000102030203020300212021202120212
// 012:253525352535253525352535253525352535253525352535253525352535000000000000000000000000000000000000000000000000000000000000253525352535253525352535253525352535253525352535253525352535000000000000000000000000000000000000000000000000000000000000031303130313031303130313031303130313031303130313031303130313000000000000000000000000000515051504141515051505150515051505150000000313031321312131011101110111213121310313031300000000031303130313213121312131213121312131213121312131031303130313
// 013:041404140414041404140414041404140414041404140414041404140414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005150000000000000000000000000000000000000002120212021202120212021202120000000000000000000000000000445402120212021202120212021202124555000000000000
// 014:051505150515051505150515051505150515051505150515051505150515000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003130313031303130313031303130000000000000000000000000000253544540313031303130313031345550000000000000000
// 015:0200003c000000003c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000025352434243424342434243400000000000000000000
// 016:021212023c3c3c3c3c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 020:000000000000000000000000000000000000000000000000000000000000263626362636263626366474000000000000657526362636263626362636263626362636647400000000000000000000000000006575263626362636000000000000000000000000000000000000000000000000000000000000263626362636263626366474000000000000657526362636263626362636000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000263626362636647400000000657526362636263626362636263626362636
// 021:000000000000000000000000000000000000000000000000000000000000273727372737253525352535647400006575253525352535273727372737273725352535253564740000000000000000000065752535253525352737000000000000000000000000000000000000000000000000000000000000273727372737253525352535647400006575253525352535273727372737000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000273725352535253564746575253525352535273727372737273727372737
// 022:001000100010001000100010001000100010001000100010001000100010001000100010465625352636263626362636263625354757001000100010001046562535263626362636647400146575263626362636253547570010001000100010001000100010001000100010001000100010001000100010001000100010465625352636263626362636263625354757001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001046562535263626362636263625354757001000100010001000100010
// 023:011101110111011101110111011101110111011101110111011101110111011101110111011146562737273727372737273747570111011101110111011101114656273725352535253564752535253525352737475701110111011101110111011101110111011101110111011101110111011101110111011101110111011146562737273727372737273747570111011101110111011101110111011101110313031303130313031301110111011101110111011101110111011101110111011101110111011101110111011101110111011101114656273727372737273747570111011101110111011101110111
// 024:203020302030203020302030203020302030203020302030203020302030203020302030203020300010001000100010001020302030203020302030203020302030001046562535263626362636253547570010203020302030203020302030203020302030021202120212203020302030203020302030203020302030203020300010001000100010001020302030203020302030203020302030203045552434243424342434243444542030203020302030203020302030203020302030203020302030203020302030203020302030203020302030001000100010001020302030203020302030203020302030
// 025:213121312131213121312131213121312131213121312131213121312131213121312131213121310111011101110111011121312131213121312131213121312131011101114656273727372737475701110111213121312131213121312131213121312131031303130313213121312131213121312131213121312131213121310111011101110111011121312131213121312131213121312131213146562737273727372737273747572131213121312131213121312131213121310313031303130313031321312131213121312131213121312131011101110111011121312131213121312131213121312131
// 026:203020302030203020300212021202120212021220302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030001000100010203020302030203020302030203020302030021202124555243424342434445402120212203020302030203020302030203020300212021202120212021220302030203020302030203020302030203020300010001000100010001020302030203020302030203020302030203045552434243424342434243444542030203020302030203020302030203020302030203020302030021202120212021220302030
// 027:213121312131213121310313031303130313031321312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131011101110111213121312131213121312131213121312131031345552535253525352535253544540313213121312131213121312131213121310313031303130313031321312131213121312131213121312131213121312131213121312131213121312131213121312131213121312131213146562737273727372737273747572131213121312131213121312131213121312131213121312131031303130313031321312131
// 028:021202120212021245552434243424342434243444540212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202124555243425352535253567762535253525352434445402120212021202120212021245552434243424342434243444540212021202120212021202120212021202120212021202120212021202120212021202120212021202120212021202120010001000100010001002120212021202120212021202120212021202120212021202124555243424342434243444540212
// 029:031303130313455525352535253525352535253525354454031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031345552535253525352535677705156676253525352535253544540313031303130313455525352535253525352535253525354454031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031303130313031345552535253525352535253525354454
// 030:243424342434253525352535677704046676253525352535243424342434253567770404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404243425352535253567770404040404040404040466762535253525352434243424342434253525352535677704046676253525352535243424342434040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404243424342434243424342434243425352535253567776676253525352535
// 031:253525352535253525356777040404040404667625352535253525352535677704040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404253525352535677704040404040404040404040404046676253525352535253525352535253525356777040404040404667625352535253525352535040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404253525352535253525352535253525352535677704040404667625352535
// 032:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
// 033:040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404
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
// 001:0123456789abcdeffedcba9876543210
// 002:0123456789abcdea0123456789abcd53
// 003:0123456789abcdef0123456789abcdef
// 005:0123456789abcdedecae9c7654421100
// 006:9744439acccefff4976ba91c55876614
// 007:0000000000000789abffffffffffffff
// 008:0000000000000000ffffffffffffffff
// 009:0000000000000005bfffffffffffffff
// </WAVES>

// <SFX>
// 000:02000200020002001200320042004200520052007200720092009200a200a200c200d200e200e200f200e200e200e200e200e200e200e200e200e200470000000000
// 001:08f83800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800680000000000
// 002:00c0007000500000310051008100c100d100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100c57000000000
// 003:02004200420062007200820092009200a200b200b200c200c200d200e200e200e200e200f200f200f200f200f200f200f200f200f200f200f200f200507000000000
// 004:068006500600f600f600f600060006000600060006000600060016001600260036004600460056006600760086009600a600b600c600d600e600f600680000000300
// 005:080008400850087008c0080018002800380048004800580058006800780078008800880098009800a800a800b800c800c800e800e800e800e800f800309000000500
// 006:0800080018001800180038405840584058406800680068007800887088709870987098709870a870b870b870c870d870f870f870f870f870f870f870500000000000
// 007:060006000600f600f600f6000670067006700670067016701670167016701670167016702670267036703670367046705670f670f670f670f670f6702f5000000000
// 008:4800010001001100110021002100310041004100510051006100710081008100a100a100b100b100c100c100d100d100d100e100e100e100e100f100770000000000
// 009:0407340364018400a40ea40d5406540464028400940fa40eb40d94058404840394019400a40eb40d94039401a40fb40ec40dc40ed40fe40ee40ef40db60000000000
// 010:4800270308040806080708070807080708060806080508031802280038004800580f580e680d780c880ba80bb80ab80ac80ad809e809e808e808f808c12011000000
// 048:04002100410f610f910ee10ef10df10df10df10df10df10df10df10df10df10df10df10df10df10df10df10df10df10df10df10df10df10df10df10dc0b000000000
// 049:64008400b400e400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400604000000000
// 050:1400640fa40ef40df40cf40bf409f408f408f408f409f409f408f408f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400b00000000000
// 051:0400440074009400a400b400d400e400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400300000000000
// 052:040046006600760fa60fc60ee60ee60ee60df60df60cf60cf60cf60bf60bf60bf60df60df60df60df60df60cf60cf60cf60cf60cf60cf60cf60cf60c300000000000
// 053:040045008500a50fe50ff50ef50ef50ef50df50df50cf50cf50cf50bf50bf50bf50df50df50df50df50df50cf50cf50cf50cf50cf50cf50cf50cf50c105000000000
// 054:64008400b400e400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400604000030000
// 055:f400f400f400040f450f950ef50ef50ef50df50df50cf50cf50cf50bf50bf50bf50df50df50df50df50df50cf50cf50cf50cf50cf50cf50cf50cf50c402000000000
// 056:06000100010001000100110011001100110021002100310051006100610071007100810081009100a100a100b100c100c100d100e100f100f100f100300000000000
// 057:27005700670077008700870087009700a700a700b700b700b700b700b700c700d700d700e700f700f700f700f700f700f700f700f700f700f700f700400000000000
// 058:0580257005502500250025004500650075008500850095009500950095009500950095009500a500950095009500a500a500b500c500c500d500e500605000000300
// 059:47005700670077008700870087009700a700a700b700b700b700b700b700c700d700d700e700f700f700f700f700f700f700f700f700f700f700f70040a000030000
// 060:b90099008900790079006900690079007900890099019902a901a900b90fc90ef90ff900f900f900f900f900f900f900f900f900f900f900f900f900405000f10098
// </SFX>

// <PATTERNS>
// 000:900895100000000000000000400895100000000000000000800895100000000000000000400895100000000000000000900895100000000000000000000000900893000000000000022600000000000000000000000000000000000000000000100000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 001:400807000000100821400807e0082f100801100821400809000000000000e0081f10084100000040081fe0082300000040081f400807e0082f00000040081f400807000000b0083900000000000040081fe0082900000040081fe00829000000400807000000e0082900000040081f400807000000b0083900000000000040081fb0084300000040081f60084300000040081f400807e0082900000040081f400807000000b0083900000000000040081fe0082900000040081fe00829e00829
// 002:400887100881400887100881800887000000000000b00887100881b00887100881b00887d00887000000b00887000000b00885100881b00885100881f00885000000000881600887100881600887100881600887800887000000600887000000400887100881400887100881800887000000000000b00887100881b00887100881b00887d00887000000b00887000000400887000000000000000000000000000000000000000000000000400887b00885000000d00885000000f00885000000
// 003:400887100881400887100881800887000000000000b00887100881b00887100881b00887d00887000000b00887000000b00885100881b00885100881f00885000000000881600887100881600887100881600887800887000000600887000000b00885100881b00885100881f00885000000000881600887100881600887100881600887800887000000600887000000400887100881400887100881800887000000000000b00887100881b00887100881b00887d00887000000b00887000000
// 004:000000000000800899100891400899000000000000b00899100891b00899100891b00899800899000000400899000000600899000000000000900899000891000000100891000000000000000000000000000000000000000000000000000000100891000000600899100891f00897000000000000900899100891900899100891900899600899000000f00897000000400899000000000000800899000891000000100891000000000000000000000000000000000000000000000000000000
// 005:900887100881900887100881d00887000000000881400889100881400889100881400889600889000000400889000000400887100881400887100881800887000000000000b00887100881b00887100881b00887d00887000000b00887000000b00885100881b00885100881f00885000000000000600887100881600887100881600887800887000000600887000000400887000000000000b00885000000000000400887000000100881400887b00885000000d00885000000f00885000000
// 006:000000000000d0089910089190089900000000000040089b10089140089b10089140089bf00899000000d00899000000b00899000000000000800899000891000000100891000000000000000000000000000000000000000000000000000000000000000000600899100891f00897000000000000900899100891900899100891900899600899000000f00897000000400899000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 007:069100000000b0089910089180089900000000000040089b10089140089b10089140089bb00899000000800899000000900899000000000000d00899000891000000100891000000000000000000000000000000000000000000000000000000069100000000900899100891600899000000000000f00899100891f00899100891f00899d00899000000b00899000000800899000000000000b00899000891000000100891000000000000000000000000000000000000000000000000000000
// 008:06910000000040089b100891d0089900000000000092499b10089190089b10089180089b60089b00000046999b000000f00899000000000000b00899000891000000100891000000000000000000000000000000000000000000000000000000069100000000900899100891600899000000000000d9a999100891b00899100891900899800899000000600899000000400899000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 009:900887100881900887100881400887000000000881900885100881400887900887000881100000000000b00887000891400887100881400887100881b00887000000000000400887100881b00887100881b00887d00887000000b00887000000b00885100881b00885100881600887000000000000b00887100881b00885b00887000881b00887000000b00885000000400887100891400887100881800887000000000000400887100881400885e00885000000d00885000000b00885000000
// 010:4fa9c90000000000000000009008c9000000000000d008c91008914ff99b10089140089bf00899000891d00899100891bfa9c90000000000000000004008cb0000000000008008c91008918ff99b40089bb0089940089bb00899800899100891ffa9c70000000000000000006008c90000000000009008c9100891dff999100891d00899b008990008919008991008918fa9c90000000000000000004008c9000891000000b008c91008918ff999b0089940089bb0089940089b80089b100891
// 011:1008c10000000000000000001008c10000000000001008c10008c1dff999100891d00899b008990008919008991008911008c10000000000000000001008c10000000000001008c10008c110089185a99b46999bb7899948799bb969998a59991008c10000000000000000001008c10000000000001008c10008c19ff9991008919008998008990008916008991008911008c10000000000000000001008c10000000000001008c10008c11008918a5999b9699948799bb7899946999b85a99b
// 012:900887100881900887100881400887000000000881900885100881400887900887000881100881000000b00887000891400887100881400887100881800887000000000000b00887100881b00887100881b00887d00887000000b00887000000b00887100881b00887100881600887000000000000b00885100881b00885b00887000881d00887000000b00887000000400887100881400887100881100881400887100881400887100881400887b00885000000d00885000000f00885000000
// 013:4fa9c90000000000000000009008c9000000000000d008c91008914ff99b10089140089bf00899000891d00899100891bfa9c90000000000000000004008cb0000000000008008c9100891bff999100891b00899900899000891800899100891bfa9c7000000000000000000f008c70000000000006008c91008919ff9991008919008998008990008916008991008914fa9c91008c14008c91008c11008c14008c91008c14008c9100891100891100891100891100891000891100891100891
// 014:1008c10000000000000000001008c10000000000001008c10008c1d00899100891d00899b008990008919008991008911008c10000000000000000001008c10000000000001008c10008c18008991008918008996008990008914008991008911008c10000000000000000001008c10000000000001008c10008c1600899100891600899400899000891f008971008918008971008918008971008911008c1800897100891800897100881100891100891100891100891000891100891100891
// 015:0008a10000009008ad0000001008a10000000000000000000000000000001008a19008ad0000000000001008a10000008008991008a1800899100891600899700899100891800899000891000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 016:40080700000040081f00000040081f000000400807b0085940081f40081fb0084300000040081fb00843400807000000b00843400807b0084300000040081f00000040081fb00843000000000000000000000000000000000000000000000000400807000000e0082900000040081f400807000000e00829000000000000000000e00829000000000000000000000000000000000000e00829000000000000000000000000000000000000000000000000000000000000000000000000000000
// 017:400887000881100881000000b00885000000100881e00885100881e00885b00885000000e00885000000f00885000000b00899400887b00899400887900899a00899400887b00899000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 018:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040089b10089140089b100891e00899f0089910089140089b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 019:b00885000000100881000000b00885100881b00885100881e00885100881e00885000000100881000000f00885000000400887000000100881000000400885000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 020:000891000000b00895000000f00895100891600897100891900897000000800897100891600897000000700897000000800897000000100891000000400897000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
// 021:40086f000861000861000861000811000811f0081f000861f0081f000861000000000000f0081f000000f0081f000000f0081f000000000000000000000000f0081ff0081f000000000000000000000000f0081ff0081f000000f0081f00000000000000000000000040086f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f0081f49998d87798db5598df4498d43398ff2298db1198d81198d41198d81198db1198d
// 022:c008b7000000000000000000100891000000000000000000c00897000891100891100891c00897100881c00897000000e00897000891000000100891000000000000c00897000891000000100891100891100891e008970000001008910000000000000000000000004008b9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400897000000000000000000000000000000000000000000000000000000000000000000
// 023:4008b90000000000000000001008910000000000000000004008990008911008911008914008991008814008990000006008990008910000001008910000000000004008990008910000001008911008911008916008990000001008910000000000000000000000008008b9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b00897000000000000000000000000000000000000000000000000000000000000000000
// 024:7008b9000000000000000000100891000000000000000000700899000891100891100891700899100881700899000000900899000891000000100891000000000000700899000891000000100891100891100891900899000000100891000000000000000000000000b008b9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400899000000000000000000000000000000000000000000000000000000000000000000
// 025:900887100881900887100881d00887000000000881400889100881400889100881400889600889000000400889000000400887100881400887100881800887000000000000b00887100881b00887100881b00887d00887000000b00887000000b00885100881b00885100881f00885000000000000600887100881600887100881600887800887000000600887000000400887000000000000b00885000000000000400885100881000000400885e00885000000d00885000000b00885000000
// 026:000000000000800899100891400899000000000000b00899100891b00899100891b0089980089900000040089900000060089900000000000090089900089100000010089100000000000090089b60089bf0089960089bf00899b00899000000100891000000600899100891f00897000000000000900899100891900899100891900899600899000000f0089700000040089900000000000080089900089100000010089100000000000080089b40089bb0089940089bb00899800899000000
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
// 001:2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007c0000
// 002:1142d4000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000de0200
// 003:115510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ae0200
// 004:6d5856000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f000ef
// </TRACKS>

// <PALETTE>
// 000:00000068605cb0b0b8fcfcfc1c38ac7070fca82814fc484820880070f828b82cd0fc74ecac581cf8a8503cd4e4f8ec20
// </PALETTE>

