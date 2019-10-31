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
    strokeWidth: 1,
  },
  characterStates: {
    faded: {
      fill: '#999',
      opacity: 0.4,
      characterState: 'faded',
    },
    highlighted: {
      fill: 'red',
      opacity: 0.4,
      characterState: 'highlighted',
    },
    selected: {
      fill: 'red',
      opacity: 1,
      characterState: 'selected',
    }
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

let characterGrid = new Array(29);
for (let y = 0; y < characterGrid.length; y++) {
  characterGrid[y] = new Array(29);
}

const render = ({ characters, segments }) => {
  let state = {
    highlightedChars: [],
    selectedSegmentIds: [],
  };

  let stage = new Konva.Stage({
    container: 'container',   // id of container <div>
    width: window.innerWidth,
    height: constants.stage.height,
  });

  let layer0 = new Konva.Layer();
  let layer1 = new Konva.Layer();
  let layer2 = new Konva.Layer();
  let layers = [layer0, layer1, layer2];

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
      strokeWidth: constants.characters.strokeWidth,
      character: character,
    });

    newText.setAttr('segmentIds', character.segment_ids.map(id => id.toString()));

    if (character.rhyme) {
      newText.name('rhyme');
    }

    characterGrid[character.y_coordinate][character.x_coordinate] = newText;

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
  layer0.add(gridBackground);

  let focusText = new Konva.Text({
    x: gridBackground.width() + constants.focusText.marginLeft,
    y: 0,
    text: '',
    fontFamily: 'Ma Shan Zheng',
    fontSize: constants.focusText.fontSize,
  });
  layer2.add(focusText);

  let resetButton = new Konva.Text({
    x: focusText.x() + 70,
    y: stage.height() / 3,
    text: 'reset',
    fontFamily: 'Roboto Mono',
    fontSize: 18,
    padding: 5,
    fill: 'red',
  });

  const resetButtonClick = () => {
    stage.destroy();
    render(data);
  }

  layer2.add(resetButton);
  resetButton.on('click', resetButtonClick);

  let startButtonRed = new Konva.Label({
    x: focusText.x(),
    y: stage.height() / 3,
  });

  startButtonRed.add(
    new Konva.Tag({
      fill: 'red'
    })
  );

  startButtonRed.add(
    new Konva.Text({
      text: 'start',
      fontFamily: 'Roboto Mono',
      fontSize: 18,
      padding: 5,
      fill: 'white'
    })
  );

  const startButtonRedClick = () => {
    let fadeOutGridBackground = new Konva.Tween({
      node: gridBackground,
      duration: 1,
      opacity: 0,
    });

    fadeOutGridBackground.play();

    characterTexts.forEach((char) => {
      let x = char.x();
      let y = char.y();
      let size = char.fontSize();
      let opacity = 0;
      let fill = char.fill();

      // set fade-out attrs
      if (char.fill() == 'red') {
        if (char.name().match('rhyme')) {
          opacity = constants.characterStates.highlighted.opacity;
          fill = constants.characterStates.highlighted.fill;
        } else {
          opacity = constants.characterStates.faded.opacity;
          fill = constants.characterStates.faded.fill;
        }
      }

      // bind events
      if (char.fill() == 'red') {
        char.on('mouseover', charMouseover.bind(this, char));
        char.on('mouseleave', charMouseleave.bind(this, char));
        char.on('click', charClick.bind(this, char));
      }

      let fadeOut = new Konva.Tween({
        node: char,
        duration: 1,
        opacity: opacity,
        fill: fill,
        fontSize: size,
        x: x,
        y: y,
      });

      fadeOut.play();
    });

    startButtonRed.destroy();
  }

  layer2.add(startButtonRed);
  startButtonRed.on('click', startButtonRedClick);

  const segmentsForChar = (charText) => {
    const segmentIds = charText.getAttr('segmentIds');
    return segmentIds.map(segmentId => segments[segmentId]);
  }

  const segmentEachChar = (segment, fn) => {
    if (segment.head_x == segment.tail_x) {
      // vertical segment
      const lower = Math.min(segment.head_y, segment.tail_y);
      const higher = Math.max(segment.head_y, segment.tail_y);
      for (let y = lower; y <= higher; y++) {
        let charInSegment = characterGrid[y][segment.head_x];
        fn(charInSegment);
      }
    } else if (segment.head_y == segment.tail_y) {
      // horizontal segment
      const lower = Math.min(segment.head_x, segment.tail_x);
      const higher = Math.max(segment.head_x, segment.tail_x);
      for (let x = lower; x <= higher; x++) {
        let charInSegment = characterGrid[segment.head_y][x];
        fn(charInSegment);
      }
    } else {
      // diagonal segment
    }
  }

  const charIsSelected = (charText) => {
    return (charText.getAttr('characterState') == 'selected');
  }

  const charMouseover = (charText) => {
    if (charIsSelected(charText)) {
      return;
    }

    segmentsForChar(charText).forEach(segment => {
      segmentEachChar(segment, (charInSegment) => {
        charInSegment.fill('red');
        state.highlightedChars.push(charInSegment);
      });
    });

    layer2.batchDraw();
  }

  const charMouseleave = (charText) => {
    state.highlightedChars.forEach(char => {
      if (char.name().match('rhyme') || charIsSelected(char)) {
        return;
      }
      char.fill(constants.characterStates.faded.fill);
    });
    state.highlightedChars = [];

    layer2.batchDraw();
  }

  const charClick = (charText) => {
    if (charText.name().match('rhyme')) {
      return;
    }

    const segments = segmentsForChar(charText);
    if (segments.length == 0) {
      return;
    }

    // now proceeding to select the segment

    // let's just take the first segment for now
    const segment = segmentsForChar(charText)[0];

    state.selectedSegments.push(segment);

    segmentEachChar(segment, (charInSegment) => {
      charInSegment.setAttrs(constants.characterStates.selected);
    });

    layer2.batchDraw();
  }

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
    layer2.add(newLine);

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
    // updateFocusText(characterText);
    // updateTrace(characterText);
    layer2.draw();

    lastFocusedCharacter = characterText;
  }

  characterTexts.forEach((characterText) => {
    layer2.add(characterText);

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

  layers.forEach(layer => {
    stage.add(layer);
    layer.draw();
  });

}

$('.footer').hide();

let data;

$.when(
  $.ajax({
    url: '/characters.json'
  }),
  $.ajax({
    url: '/segments.json'
  })
).then((charactersResponse, segmentsResponse) => {
  data = {
    characters: charactersResponse[0]["characters"],
    segments: segmentsResponse[0]["segments"],
  };
  render(data);
  $('.footer').show();
});
