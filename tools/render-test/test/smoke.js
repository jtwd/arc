/* Headless smoke test. Stubs just enough DOM to run the prototype's real code,
   then drives every room kind and every creature through several hundred
   frames of step + draw. It cannot tell you whether the bear looks like a bear;
   it can tell you that nothing in rung 7 throws. */
var fs = require('fs'), path = require('path');
var D = require('path').join(__dirname, '..');

var src = fs.readFileSync(D + '/index.html', 'utf8');
var parts = src.match(/<script>[\s\S]*?<\/script>/g).map(function(p){
  return p.replace(/^<script>/, '').replace(/<\/script>$/, '');
});
var js = parts.join('\n;\n');
/* expose the closure for the test only */
js = js.replace(/\n\}\)\(\);\s*$/,
  '\n  globalThis.__T = {startRun:startRun, enterRoom:enterRoom, step:step, draw:render,' +
  ' run:run, hero:hero, spawnFoe:spawnFoe, killFoe:killFoe, makeDoors:makeDoors,' +
  ' foes:function(){return foes;}, takeDoor:takeDoor, stepRun:stepRun,' +
  ' hurtHero:hurtHero, WARES:WARES, DOORS:DOORS};\n})();\n');
if(js.indexOf('globalThis.__T') < 0) throw new Error('could not expose closure');

/* ---- DOM stubs ---- */
function mkCtx(cv){
  var o = {canvas:cv, globalAlpha:1, fillStyle:'#000', strokeStyle:'#000',
           font:'', textAlign:'left', lineWidth:1, lineCap:'butt', lineJoin:'miter',
           globalCompositeOperation:'source-over'};
  ['beginPath','closePath','moveTo','lineTo','quadraticCurveTo','arc','ellipse',
   'fill','stroke','clip','save','restore','translate','rotate','scale',
   'setTransform','clearRect','fillRect','fillText','drawImage'].forEach(function(k){
    o[k] = function(){};
  });
  o.measureText = function(t){ return {width: (t||'').length*6}; };
  o.createLinearGradient = function(){ return {addColorStop:function(){}}; };
  o.createImageData = function(w,h){ return {width:w, height:h, data:new Uint8ClampedArray(w*h*4)}; };
  o.getImageData = function(x,y,w,h){ return {width:w, height:h, data:new Uint8ClampedArray(w*h*4)}; };
  o.putImageData = function(){};
  o.createPattern = function(){ return {}; };
  o.createRadialGradient = function(){ return {addColorStop:function(){}}; };
  return o;
}
function mkEl(tag){
  var el = {tagName:(tag||'div').toUpperCase(), width:960, height:600,
            clientWidth:960, clientHeight:600, style:{}, textContent:'',
            checked:false, value:'', children:[]};
  el.getContext = function(){ if(!el.__c) el.__c = mkCtx(el); return el.__c; };
  el.addEventListener = function(){};
  el.removeEventListener = function(){};
  el.appendChild = function(c){ el.children.push(c); return c; };
  el.setAttribute = function(){}; el.getAttribute = function(){ return null; };
  el.getBoundingClientRect = function(){ return {left:0, top:0, width:960, height:600}; };
  el.setPointerCapture = function(){}; el.releasePointerCapture = function(){};
  el.classList = {add:function(){}, remove:function(){}, toggle:function(){}};
  el.focus = function(){};
  return el;
}
var els = {};
globalThis.document = {
  getElementById: function(id){ if(!els[id]) els[id] = mkEl('div'); return els[id]; },
  createElement: mkEl,
  addEventListener: function(){},
  body: mkEl('body'),
  documentElement: mkEl('html'),
  fonts: {ready: Promise.resolve()}
};
var store = {};
globalThis.localStorage = {
  getItem:function(k){ return k in store ? store[k] : null; },
  setItem:function(k,v){ store[k] = String(v); },
  removeItem:function(k){ delete store[k]; }
};
globalThis.window = globalThis;
globalThis.devicePixelRatio = 1;
globalThis.innerWidth = 960; globalThis.innerHeight = 600;
globalThis.matchMedia = function(){ return {matches:false, addEventListener:function(){}, addListener:function(){}}; };
globalThis.addEventListener = function(){};
globalThis.removeEventListener = function(){};
globalThis.requestAnimationFrame = function(){ return 0; };
globalThis.cancelAnimationFrame = function(){};
globalThis.performance = globalThis.performance || {now:function(){ return Date.now(); }};
globalThis.navigator = {userAgent:'node', maxTouchPoints:0};

/* ---- load ---- */
var fail = null;
try { (0, eval)(js); } catch(e){ console.log('LOAD FAILED: ' + (e && e.stack || e)); process.exit(1); }
var T = globalThis.__T;
if(!T) { console.log('no closure'); process.exit(1); }

var problems = [];
function frames(n, label){
  for(var i=0;i<n;i++){
    try { T.step(1/60); T.draw(); }
    catch(e){ problems.push(label + ' frame ' + i + ': ' + (e && e.stack || e)); return false; }
  }
  return true;
}

/* every creature, every state, both elite and plain, at several depths */
var KINDS = ['wolf','boar','hunter','bear'];
var ELITES = [null,'hardened','swift','deeper'];
T.startRun();
for(var ki=0; ki<KINDS.length; ki++){
  for(var ei=0; ei<ELITES.length; ei++){
    try {
      T.enterRoom(3, 'fight');
      T.foes().length = 0;
      for(var d=0; d<3; d++){
        T.spawnFoe(KINDS[ki], ELITES[ei], {x:200+d*250, y:260+d*120});
      }
    } catch(e){ problems.push('spawn ' + KINDS[ki] + '/' + ELITES[ei] + ': ' + e); continue; }
    frames(260, KINDS[ki] + '/' + (ELITES[ei]||'plain'));
  }
}

/* the bear specifically, driven through every one of its states */
T.enterRoom(3, 'fight');
T.foes().length = 0;
var bear = T.spawnFoe('bear', null, {x:480, y:300});
['approach','swipe','grab','roar'].forEach(function(st){
  bear.state = st; bear.timer = 0.9;
  if(!frames(120, 'bear state ' + st)) return;
});
/* the grab, taken to its conclusion and then escaped */
T.hero.held = {by:bear, t:0};
frames(90, 'held');
T.hero.dashUsed = 0;
try { T.hero.held = T.hero.held || {by:bear, t:0}; } catch(e){}

/* every room kind */
['fight','flint','elite','altar','shop','spring','story','boss'].forEach(function(k){
  try { T.enterRoom(k === 'boss' ? 7 : 3, k); }
  catch(e){ problems.push('enterRoom ' + k + ': ' + (e && e.stack || e)); return; }
  frames(420, 'room ' + k);
});

/* the shop, bought out */
T.enterRoom(3, 'shop');
T.run.flint = 500;
for(var w=0; w<(T.run.wares||[]).length; w++){
  T.hero.x = T.run.wares[w].x; T.hero.y = T.run.wares[w].y;
  frames(60, 'buy ' + T.run.wares[w].id);
}
/* and with nothing in the purse */
T.enterRoom(3, 'shop');
T.run.flint = 0;
T.hero.x = T.run.wares[0].x; T.hero.y = T.run.wares[0].y;
frames(120, 'broke shop');

/* every door kind, taken */
Object.keys(T.DOORS).forEach(function(k){
  try {
    T.enterRoom(3, 'fight');
    T.foes().length = 0;
    frames(20, 'clear for ' + k);
    T.run.state = 'cleared';
    T.takeDoor({kind:k});
    frames(240, 'through ' + k + ' door');
  } catch(e){ problems.push('door ' + k + ': ' + (e && e.stack || e)); }
});

/* a whole run, doors picked at random, rooms cleared by fiat */
for(var r=0; r<12; r++){
  T.startRun();
  for(var g=0; g<40 && T.run.state !== 'done'; g++){
    if(!frames(30, 'run ' + r)) break;
    T.foes().length = 0;
    frames(20, 'run ' + r + ' clear');
    if(T.run.doors && T.run.doors.length && (T.run.state === 'cleared' || T.run.state === 'shop')){
      T.takeDoor(T.run.doors[Math.floor(Math.random()*T.run.doors.length)]);
      frames(80, 'run ' + r + ' wash');
    } else if(T.run.state === 'story'){
      frames(600, 'run ' + r + ' story');
    } else if(T.run.state === 'altar'){
      T.run.state = 'cleared'; T.makeDoors();
    }
  }
}

if(problems.length){
  console.log('PROBLEMS (' + problems.length + '):');
  problems.slice(0, 12).forEach(function(p){ console.log('  - ' + p); });
  process.exit(1);
}
console.log('SMOKE OK  — all creatures, all rooms, all doors, 12 full runs, no throws');
