/*document.addEventListener("DOMContentLoaded", function () {
  document.querySelector('.artem .mouth').addEventListener(
    'click',
    function(event) {
      var t = event.currentTarget;
      var ls = t.classList;
      if (ls.contains('opened')) {
        ls.remove('opened');
        ls.add('closed');
      } else {
        ls.remove('closed');
        ls.add('opened');
      }
    }
  )
})*/

document.addEventListener('keydown', function (event) {
  if (event.keyCode == 32) {
    var a = document.querySelector('.artem');
    if (a.classList.contains('jump')) return;
    let it = 0;
    a.addEventListener('animationend', function(e) {
      if (it++ > 0) {
        e.currentTarget.classList.remove('jump');
        it = 0;
      }
    })
    a.classList.add('jump');
  }
})
