/* Does every figure fit inside the 360x360 character buffer at maximum depth?
   A clipped muzzle is invisible to a syntax check and obvious to a player, so
   the transform stack is tracked for real and every painted point measured. */
var fs = require('fs');
var D = require('path').join(__dirname, '..');
var src = fs.readFileSync(D + '/index.html', 'utf8');
var js = src.match(/<script>[\s\S]*?<\/script>/g).map(function(p){
  return p.replace(/^<script>/,'').replace(/<\/script>$/,'');
}).join('\n;\n');
js = js.replace(/\n\}\)\(\);\s*$/,
  '\n  globalThis.__T = {drawFoe:drawFoe, drawHero:drawHero, hero:hero,' +
  ' charCtx:charCtx, CB:CB, CBX:CBX, CBY:CBY, setArt:function(v){artScale=v;}};\n})();\n');

function M(){ return [1,0,0,1,0,0]; }
function mul(a,b){ return [a[0]*b[0]+a[2]*b[1], a[1]*b[0]+a[3]*b[1],
                           a[0]*b[2]+a[2]*b[3], a[1]*b[2]+a[3]*b[3],
                           a[0]*b[4]+a[2]*b[5]+a[4], a[1]*b[4]+a[3]*b[5]+a[5]]; }
function mkCtx(cv, track){
  var m = M(), stack = [];
  var o = {canvas:cv, globalAlpha:1, fillStyle:'#000', strokeStyle:'#000', font:'',
           textAlign:'left', lineWidth:1, lineCap:'butt', lineJoin:'miter',
           globalCompositeOperation:'source-over'};
  o.box = null;
  function pt(x, y){
    if(!track || !o.tracking) return;
    var px = m[0]*x + m[2]*y + m[4], py = m[1]*x + m[3]*y + m[5];
    if(!o.box) o.box = {x0:px, x1:px, y0:py, y1:py};
    else { o.box.x0=Math.min(o.box.x0,px); o.box.x1=Math.max(o.box.x1,px);
           o.box.y0=Math.min(o.box.y0,py); o.box.y1=Math.max(o.box.y1,py); }
  }
  o.save = function(){ stack.push(m.slice()); };
  o.restore = function(){ if(stack.length) m = stack.pop(); };
  o.translate = function(x,y){ m = mul(m, [1,0,0,1,x,y]); };
  o.rotate = function(a){ m = mul(m, [Math.cos(a),Math.sin(a),-Math.sin(a),Math.cos(a),0,0]); };
  o.scale = function(x,y){ m = mul(m, [x,0,0,y,0,0]); };
  o.setTransform = function(a,b,c,d,e,f){ m = [a,b,c,d,e,f]; stack.length = 0; };
  o.moveTo = pt; o.lineTo = pt;
  o.quadraticCurveTo = function(cx,cy,x,y){ pt(cx,cy); pt(x,y); };
  ['beginPath','closePath','fill','stroke','clip','clearRect','fillRect',
   'fillText','drawImage','arc','ellipse','putImageData'].forEach(function(k){ o[k]=function(){}; });
  o.measureText = function(t){ return {width:(t||'').length*6}; };
  o.createLinearGradient = o.createRadialGradient = function(){ return {addColorStop:function(){}}; };
  o.createImageData = o.getImageData = function(w,h){ return {width:w,height:h,data:new Uint8ClampedArray(w*h*4)}; };
  o.createPattern = function(){ return {}; };
  return o;
}
var els = {};
function mkEl(){
  var el = {width:960, height:600, clientWidth:960, clientHeight:600, style:{},
            textContent:'', checked:false, children:[], classList:{add:function(){},remove:function(){},toggle:function(){}}};
  el.getContext = function(){ if(!el.__c) el.__c = mkCtx(el, true); return el.__c; };
  el.addEventListener = el.removeEventListener = function(){};
  el.appendChild = function(c){ return c; };
  el.setAttribute = function(){}; el.getAttribute = function(){ return null; };
  el.getBoundingClientRect = function(){ return {left:0,top:0,width:960,height:600}; };
  el.setPointerCapture = el.releasePointerCapture = el.focus = function(){};
  return el;
}
globalThis.document = {getElementById:function(id){ if(!els[id]) els[id]=mkEl(); return els[id]; },
  createElement:mkEl, addEventListener:function(){}, body:mkEl(), documentElement:mkEl(),
  fonts:{ready:Promise.resolve()}};
var store = {};
globalThis.localStorage = {getItem:function(k){return k in store?store[k]:null;},
  setItem:function(k,v){store[k]=String(v);}, removeItem:function(k){delete store[k];}};
globalThis.window = globalThis;
globalThis.devicePixelRatio = 1;
globalThis.matchMedia = function(){ return {matches:false, addEventListener:function(){}, addListener:function(){}}; };
globalThis.addEventListener = globalThis.removeEventListener = function(){};
globalThis.requestAnimationFrame = function(){ return 0; };
globalThis.performance = globalThis.performance || {now:function(){return Date.now();}};
globalThis.navigator = {userAgent:'node', maxTouchPoints:0};

(0, eval)(js);
var T = globalThis.__T;
var cc = T.charCtx, CB = T.CB, CBX = T.CBX, CBY = T.CBY;

function measure(label, fn){
  var worst = null;
  for(var i=0;i<240;i++){
    cc.box = null; cc.tracking = true;
    try { fn(i); } catch(e){ console.log(label + ': THREW ' + e); cc.tracking=false; return; }
    cc.tracking = false;
    var b = cc.box;
    if(!b) continue;
    var over = Math.max(-b.x0, b.x1-CB, -b.y0, b.y1-CB);
    if(!worst || over > worst.over) worst = {over:over, b:b};
  }
  if(!worst){ console.log('  ' + label + ': nothing drawn'); return; }
  var b = worst.b;
  var tag = worst.over > 0 ? 'CLIPS by ' + worst.over.toFixed(0) + 'px' : 'fits, ' + (-worst.over).toFixed(0) + 'px spare';
  console.log('  ' + pad(label) + ' x ' + b.x0.toFixed(0) + '..' + b.x1.toFixed(0) +
              '   y ' + b.y0.toFixed(0) + '..' + b.y1.toFixed(0) + '   ' + tag);
  if(worst.over > 0) process.exitCode = 1;
}
function pad(s){ return (s + '                    ').slice(0, 20); }

console.log('character buffer ' + CB + 'x' + CB + ', origin (' + CBX + ',' + CBY + ')');
T.setArt(1);
/* y 592 is the bottom of the arena, where depth() and therefore scale peak */
['wolf','boar','hunter','bear'].forEach(function(k){
  var states = k === 'bear' ? ['approach','swipe','grab','roar'] :
               k === 'boar' ? ['approach','wind','charge','stun'] :
               k === 'hunter' ? ['hold','aim','throw'] : ['approach'];
  states.forEach(function(st){
    var f = {kind:k, x:480, y:592, face:1, step:0, seed:140, state:st, flash:0,
             squash:0, hp:100, maxHp:100, timer:0.9};
    measure(k + ' ' + st, function(i){
      f.step = i*0.13;
      f.timer = 0.9 * (1 - i/240);
      T.drawFoe(f);
    });
  });
});
measure('alegus', function(i){
  T.hero.x = 480; T.hero.y = 592; T.hero.step = i*0.13; T.hero.gait = 1;
  T.drawHero();
});
/* and the sheet, where everything is drawn at 1.75 */
console.log('at sheet scale 1.75:');
T.setArt(1.75);
var sb = {kind:'bear', x:480, y:500, face:1, step:0, seed:520, state:'approach',
          flash:0, squash:0, hp:220, maxHp:220, scale:0.62, timer:0};
measure('bear (sheet)', function(i){ sb.step = i*0.13; T.drawFoe(sb); });
measure('alegus (sheet)', function(i){
  T.hero.x = 140; T.hero.y = 500; T.hero.step = i*0.13; T.hero.gait = 1;
  T.drawHero();
});
