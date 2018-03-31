const dict = {};
let counter = 0;

const setPoints = () => {
  [].forEach.call(document.querySelectorAll('div'), (div) => {
    const el = document.createElement('div');
    const [left, top] = window.getComputedStyle(div).transformOrigin.split(' ');
    el.innerHTML = "*";
    el.classList.add('origin');
    el.id = counter++;
    dict[el.id] = div;
    el.style.position = 'absolute';
    el.style.top = top;
    el.style.left = left;
    el.style.fontSize = '24px';
    el.style.zIndex = '100';
    div.appendChild(el);
  });
}

const updatePoints = () => {
  [].forEach.call(document.querySelectorAll('.origin'), (el) => {
    const div = dict[el.id];
    const [left, top] = window.getComputedStyle(div).transformOrigin.split(' ');
    el.style.top = top;
    el.style.left = left;
  });
}

setPoints();
const int = setInterval(()=>{
  updatePoints();
}, 100);
