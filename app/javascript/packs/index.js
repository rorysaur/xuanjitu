const constants = {
  background: {
    width: 750,
    height: 750,
    color: '#eee',
  },
  characters: {
    width: 25,
    height: 25,
    colorMappings: {
      black: 'black',
      blue: 'blue',
      green: 'green',
      purple: 'purple',
      red: 'red',
      yellow: '#fc0',
    },
    fontSize: 20,
  },
  fadeIn: {
    maxDuration: 6,
  },
  focusText: {
    marginLeft: 20,
    fontSize: 200,
  },
  stage: {
    height: 750,
  },
  text: {
    offset: {
      x: 10,
      y: 10,
    }
  },
  trace: {
    color: "#999",
    strokeWidth: 2,
    fadeDuration: 1,
  }
};

const render = ({ characters }) => {
  let stage = new Konva.Stage({
    container: 'container',   // id of container <div>
    width: window.innerWidth,
    height: constants.stage.height,
  });

  let layer = new Konva.Layer();

  let characterTexts = characters.map((character) => {
    const { width, height, colorMappings, fontSize } = constants.characters;
    const { offset } = constants.text;

    const newText = new Konva.Text({
      x: (character.x_coordinate * width) + offset.x,
      y: (character.y_coordinate * height) + offset.y,
      text: character.text,
      fontFamily: 'Ma Shan Zheng',
      fontSize: fontSize,
      fill: constants.characters.colorMappings[character.color],
    });

    return newText;
  });

  let characterWidth = characterTexts[0].width();
  let characterHeight = characterTexts[0].height();

  let gridBackground = new Konva.Rect({
    x: 0,
    y: 0,
    strokeWidth: 5,
    fill: constants.background.color,
    width: constants.background.width,
    height: constants.background.height,
  });
  layer.add(gridBackground);

  let focusText = new Konva.Text({
    x: gridBackground.width() + constants.focusText.marginLeft,
    y: 0,
    text: '',
    fontFamily: 'Ma Shan Zheng',
    fontSize: constants.focusText.fontSize,
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

    const { color, strokeWidth, fadeDuration } = constants.trace;

    // make new line
    let newLine = new Konva.Line({
      points: [
        getCenterX(lastFocusedCharacter),
        getCenterY(lastFocusedCharacter),
        getCenterX(characterText),
        getCenterY(characterText)
      ],
      stroke: color,
      strokeWidth: strokeWidth,
    });
    layer.add(newLine);

    if (lastLine) {
      // fade last line
      let oldLine = lastLine;
      let tween = new Konva.Tween({
        node: oldLine,
        duration: fadeDuration,
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

    // fade in text
    characterText.opacity(0);
    let fadeIn = new Konva.Tween({
      node: characterText,
      duration: Math.random() * constants.fadeIn.maxDuration,
      opacity: 1
    });
    fadeIn.play();

    characterText.on('mouseover', characterTextMouseover.bind(this, characterText));
  });

  stage.add(layer);
  layer.draw();
}

$('.footer').hide();

$.ajax({
  url: '/characters.json'
})
.done((data) => {
  render(data);
  $('.footer').show();
});
