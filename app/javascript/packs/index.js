const characters = [
  {
    id: 1,
    text: '一',
    x: 0,
    y: 0,
    color: 'black'
  },
  {
    id: 2,
    text: '二',
    x: 1,
    y: 0,
    color: 'black'
  },
  {
    id: 3,
    text: '三',
    x: 2,
    y: 0,
    color: 'black'
  },
  {
    id: 4,
    text: '四',
    x: 0,
    y: 1,
    color: 'black'
  },
  {
    id: 5,
    text: '五',
    x: 1,
    y: 1,
    color: 'green'
  },
  {
    id: 6,
    text: '六',
    x: 2,
    y: 1,
    color: 'green'
  },
  {
    id: 7,
    text: '七',
    x: 0,
    y: 2,
    color: 'black'
  },
  {
    id: 8,
    text: '八',
    x: 1,
    y: 2,
    color: 'green'
  },
  {
    id: 9,
    text: '九',
    x: 2,
    y: 2,
    color: 'green'
  },
];

let stage = new Konva.Stage({
  container: 'container',   // id of container <div>
  width: window.innerWidth,
  height: window.innerHeight
});

let layer = new Konva.Layer();

let characterTexts = characters.map((character) => {
  const newText = new Konva.Text({
    x: character.x * 20,
    y: character.y * 20,
    text: character.text,
    fontSize: 16,
    fill: character.color
  });

  return newText;
});

let gridBackground = new Konva.Rect({
  x: 0,
  y: 0,
  strokeWidth: 5,
  fill: '#eee',
  width: 600,
  height: 600,
});

let focusText = new Konva.Text({
  x: gridBackground.width() + 20,
  y: 0,
  text: '',
  fontSize: 72,
  fill: 'black',
});

layer.add(gridBackground);
layer.add(focusText);

characterTexts.forEach((characterText) => {
  layer.add(characterText);

  characterText.on('mouseover', () => {
    // change the focusText and redraw
    focusText.text(characterText.text());
    focusText.fill(characterText.fill());
    layer.draw();
  });
});

stage.add(layer);

layer.draw();
