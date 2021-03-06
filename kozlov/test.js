var egor = document.querySelector('.kozlov');
var mouth =  egor.querySelector('.mouth');
var ground = document.querySelector('.ground');
var bp = 0;
var ints = [];
var Gdirection = 0;

var step = 0.03; // количество egor.body за раз
var period = 30; //период обновлений в миллисекундах
function setMove(direction) {
  if(Gdirection=== direction) return;
  egor.classList.add('profile');
  if (direction === -1) egor.classList.add('reverse');
  ints.push(setInterval(function(){
    cw = ground.clientWidth
    bp = (bp + step * egor.clientHeight * direction + cw) % cw;
    ground.style = "background-position: "+Math.floor(bp)+'px 0';
  }, period));
  Gdirection = direction;
}

function stopMove(){
  egor.classList.remove('profile');
  egor.classList.remove('reverse');
  Gdirection = 0;
  if (ints.length > 0) {
    ints.forEach(function(int){clearInterval(int);});
    ints = [];
  }
}

function jump() {
  egor.classList.add('jump');
}

function openMouth() { mouth.classList.remove('closed'); }
function closeMouth() { mouth.classList.add('closed'); }


egor.addEventListener('animationend', function(){
  if (!egor.classList.contains('fail')) return egor.classList.add('fail');
  ['jump', 'fail'].forEach(function(k){egor.classList.remove(k)});
});

document.addEventListener('keydown', function(event) {
  var ms = {37: 1, 39: -1};
  var kk = event.keyCode;
  if (ms.hasOwnProperty(kk)) setMove(ms[kk]);
  if (kk === 32) jump();
  if (kk === 16) openMouth();
});

document.addEventListener('keyup', function(event) {
  var kk = event.keyCode;
  if (kk === 37 || kk === 39) stopMove();
  if (kk === 16) closeMouth();
});

var cs = document.querySelectorAll('.controls .key');
[].forEach.call(cs, function(key){
  key.addEventListener('touchstart', function(event){
    event.preventDefault();
    var cls = event.target.classList;
    if (cls.contains('cursor-left')) setMove(1);
    if (cls.contains('cursor-right')) setMove(-1);
    if (cls.contains('spacebar')) jump();
    cls.add('active');
  });
  function endCancelHandler (event){
    event.preventDefault();
    event.target.classList.remove('active');
    if (!event.target.classList.contains('spacebar')) stopMove();
  };
  key.addEventListener('touchend', endCancelHandler);
  key.addEventListener('touchcancel', endCancelHandler);
});

