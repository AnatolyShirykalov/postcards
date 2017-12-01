var egor = document.querySelector('.kozlov');
var container = document.querySelector('.background');
var bp = 0;
var ints = [];
var Gdirection = 0;

var step = 5.0; // количество пикселей за раз
var period = 30; //период обновлений в миллисекундах
function setMove(direction) {
  if(Gdirection=== direction) return;
  egor.classList.add('profile');
  if (direction === -1) egor.classList.add('reverse');
  ints.push(setInterval(function(){
    cw = container.clientWidth
    bp = (bp + step * direction + cw) % cw;
    container.style = "background-position: "+Math.floor(bp)+'px 0';
  }, period));
  Gdirection = direction;
}

document.addEventListener('keydown', function(event) {
  console.log(event.keyCode);
  switch(event.keyCode){
    case 37:
      setMove(1);
      break;
    case 39:
      setMove(-1);
      break;
    default:
      return;
  }
  if (event.keyCode === 37) {
    event.preventDefault();
    setMove(1);
  }
});

document.addEventListener('keyup', function(event) {
  if (event.keyCode === 37 || event.keyCode === 39) {
    egor.classList.remove('profile');
    egor.classList.remove('reverse');
    Gdirection = 0;
    if (ints.length > 0) {
      ints.forEach(function(int){clearInterval(int);});
      ints = [];
    }
  }
});

