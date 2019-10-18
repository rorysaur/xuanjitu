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
    x: character.x * 25,
    y: character.y * 25,
    text: character.text,
    fontFamily: 'Ma Shan Zheng',
    fontSize: 20,
    fill: character.color
  });

  return newText;
});

let characterWidth = characterTexts[0].width();
let characterHeight = characterTexts[0].height();

let gridBackground = new Konva.Rect({
  x: 0,
  y: 0,
  strokeWidth: 5,
  fill: '#eee',
  width: 750,
  height: 750,
});
layer.add(gridBackground);

let focusText = new Konva.Text({
  x: gridBackground.width() + 20,
  y: 0,
  text: '',
  fontFamily: 'Ma Shan Zheng',
  fontSize: 96,
  fill: 'black',
});
layer.add(focusText);

const getCenterX = (character) => {
  return character.x() + (characterWidth / 2);
}
const getCenterY = (character) => {
  return character.y() + (characterHeight / 2);
}

let lastFocusedCharacter, lastLine;

const updateFocusText = (characterText) => {
  focusText.text(characterText.text());
  focusText.fill(characterText.fill());
}

const updateTrace = (characterText) => {
  if (!lastFocusedCharacter) { return }

  // make new line
  let newLine = new Konva.Line({
    points: [
      getCenterX(lastFocusedCharacter),
      getCenterY(lastFocusedCharacter),
      getCenterX(characterText),
      getCenterY(characterText)
    ],
    fill: '#999',
    stroke: '#999',
    strokeWidth: 1
  });
  layer.add(newLine);

  if (lastLine) {
    // fade last line
    let oldLine = lastLine;
    let tween = new Konva.Tween({
      node: oldLine,
      duration: 1,
      points: [
        oldLine.points()[2],
        oldLine.points()[3],
        oldLine.points()[2],
        oldLine.points()[3]
      ],
      onFinish: () => { oldLine.destroy() }
    });

    tween.play();
  }

  lastLine = newLine;
}

const characterTextMouseover = (characterText) => {
  updateFocusText(characterText);
  updateTrace(characterText);
  layer.draw();

  lastFocusedCharacter = characterText;
}

characterTexts.forEach((characterText) => {
  layer.add(characterText);
  characterText.on('mouseover', characterTextMouseover.bind(this, characterText));
});

stage.add(layer);
layer.draw();
