import Konva from 'konva';

const constants = {
  background: {
    width: 750,
    height: 750,
    color: '#eee',
  },
  buttons: {
    marginLeft: 20,
    y: 30,
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
    y: 500
  },
  instructionText: {
    marginLeft: 20,
    y: 100,
  },
  readingText: {
    lineHeight: 45,
    marginLeft: 20,
    fontSize: 30,
    y: 300,
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

let characterGrid: Konva.Text[][] = new Array(29);
for (let y = 0; y < characterGrid.length; y++) { // check for loops
  characterGrid[y] = new Array(29);
}

const render = ({ characters, segments }) => {
  let state: any = {
    highlightedChars: [],
    selectedSegmentIds: [],
  };

  let stage: Konva.Stage = new Konva.Stage({
    container: 'container',   // id of container <div>
    width: window.innerWidth,
    height: constants.stage.height,
  });

  let layer0: Konva.Layer = new Konva.Layer();
  let layer1: Konva.Layer = new Konva.Layer();
  let layer2: Konva.Layer = new Konva.Layer();
  let layers: Konva.Layer[] = [layer0, layer1, layer2];

  let characterTexts = characters.map((character) => {
    const { width, height, colorMappings, fontSize } = constants.characters; // check destructuring
    const { offset } = constants.text;

    const newText: Konva.Text = new Konva.Text({
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

  let characterWidth: number = characterTexts[0].width();
  let characterHeight: number = characterTexts[0].height();

  let gridBackground: Konva.Rect = new Konva.Rect({
    x: 0,
    y: 0,
    strokeWidth: 5,
    fill: constants.background.color,
    width: constants.background.width,
    height: constants.background.height,
  });
  layer0.add(gridBackground);

  let focusText: Konva.Text = new Konva.Text({
    x: gridBackground.width() + constants.focusText.marginLeft,
    y: constants.focusText.y,
    text: '',
    fontFamily: 'Ma Shan Zheng',
    fontSize: constants.focusText.fontSize,
  });
  layer2.add(focusText);

  let startButtonRed: Konva.Label = new Konva.Label({
    x: gridBackground.width() + constants.buttons.marginLeft,
    y: constants.buttons.y,
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
      let x: number = char.x();
      let y: number = char.y();
      let size: number = char.fontSize();
      let opacity: number = 0;
      let fill: string = char.fill();

      // set fade-out attrs
      if (char.fill() === 'red') {
        if (char.name().match('rhyme')) {
          opacity = constants.characterStates.highlighted.opacity;
          fill = constants.characterStates.highlighted.fill;
        } else {
          opacity = constants.characterStates.faded.opacity;
          fill = constants.characterStates.faded.fill;
        }
      }

      // bind events
      if (char.fill() === 'red') {
        char.on('mouseover', charMouseover.bind(this, char));
        char.on('mouseleave', charMouseleave.bind(this, char));
        char.on('click tap', charClick.bind(this, char));
      }

      let fadeOut: Konva.Tween = new Konva.Tween({
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

    setInstructionText('unselected');
  }

  layer2.add(startButtonRed);
  startButtonRed.on('click tap', startButtonRedClick);

  let resetButton: Konva.Text = new Konva.Text({
    x: startButtonRed.x() + 70,
    y: constants.buttons.y,
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
  resetButton.on('click tap', resetButtonClick);

  const instructionText: Konva.Text = new Konva.Text({
    x: gridBackground.width() + constants.instructionText.marginLeft,
    y: constants.instructionText.y,
    text: 'hi there!',
    fontFamily: 'Roboto Mono',
    fontSize: 14,
    fill: 'black',
    width: 200,
  });
  layer2.add(instructionText);

  const setInstructionText = readingState => {
    const segmentsRemaining: number = 4 - state.selectedSegmentIds.length;
    let text: string;

    if (readingState === 'unselected') {
      text = `click on a segment to add it to your reading.\n\n\
words in light red are rhyme words.\n\n\
add ${segmentsRemaining} more segments!`;
    } else if (readingState === 'selected') {
      text = `you can click on a segment again to reverse it.\
(this also changes the rhyme word.)\n\n\
you can click once more to unselect the segment.\n\n\
add ${segmentsRemaining} more segments!`;
    } else if (readingState === 'complete') {
      text = `you have a complete 4-line poem!`;
    }

    instructionText.text(text);
  }

  const segmentsForChar = (charText) => {
    const segmentIds: string[] = charText.getAttr('segmentIds'); // check ?
    return segmentIds.map(segmentId => segments[segmentId]);
  }

  const segmentEachChar = (segment, fn) => {
    let mapped: any[] = [];

    const callFnForCoordinates = (x, y) => {
      let charInSegment: Konva.Text = characterGrid[y][x];
      let result = fn(charInSegment);
      mapped.push(result);
    }

    if (segment.head_x === segment.tail_x) {
      // vertical segment
      let y: number = segment.head_y;
      while (y !== segment.tail_y) {
        callFnForCoordinates(segment.head_x, y);
        y += (segment.head_y < segment.tail_y) ? 1 : -1;
      }
      callFnForCoordinates(segment.tail_x, segment.tail_y);

    } else if (segment.head_y === segment.tail_y) {
      // horizontal segment
      let x: number = segment.head_x;
      while (x !== segment.tail_x) {
        callFnForCoordinates(x, segment.head_y);
        x += (segment.head_x < segment.tail_x) ? 1 : -1;
      }
      callFnForCoordinates(segment.tail_x, segment.tail_y);
    } else {
      // diagonal segment
    }

    return mapped;
  }

  const currentReading: Konva.Group = new Konva.Group({
    x: gridBackground.width() + constants.readingText.marginLeft,
    y: constants.readingText.y,
  });
  layer2.add(currentReading);

  const textForSegment = (segment, index) => {
    const text: string = segmentEachChar(segment, char => char.text()).join('');

    return new Konva.Text({
      x: 0,
      y: index * constants.readingText.lineHeight,
      text: text,
      fontFamily: 'Ma Shan Zheng',
      fontSize: constants.readingText.fontSize,
      fill: 'red',
      segmentId: segment.id,
    });
  }

  const charIsSelected = (charText) => {
    return (charText.getAttr('characterState') === 'selected');
  }

  const resetCharacterState = (charText) => {
    let characterState: string;
    if (charText.name().match('rhyme')) {
      characterState = 'highlighted';
    } else {
      characterState = 'faded';
    }

    charText.setAttrs(constants.characterStates[characterState]);
  }


  const updateCurrentReading = () => {
    // destroy old text objects
    const oldTexts: any = currentReading.getChildren();
    currentReading.removeChildren();
    oldTexts.each(text => text.destroy());

    // create new text objects
    const selectedSegments: any[] = state.selectedSegmentIds.map(segmentId => segments[segmentId]);

    selectedSegments.forEach((segment, index) => {
      const textObject: Konva.Text = textForSegment(segment, index);
      currentReading.add(textObject);
    });

    layer2.batchDraw();
  }

  const playCurrentReading = () => {
    // destroy old text objects
    const oldTexts: any = currentReading.getChildren();
    currentReading.removeChildren();
    oldTexts.each(text => text.destroy());

    // create new text objects
    const selectedSegments: any[] = state.selectedSegmentIds.map(segmentId => segments[segmentId]);

    let delay: number = 0;

    selectedSegments.forEach((segment, index) => {
      const y: number = index * constants.readingText.lineHeight;
      let x: number = 0;

      segmentEachChar(segment, char => {
        const charText: Konva.Text = new Konva.Text({
          x: x,
          y: y,
          text: char.text(),
          fontFamily: 'Ma Shan Zheng',
          fontSize: constants.readingText.fontSize,
          fill: 'red',
          opacity: 0,
          segmentId: segment.id,
        });

        currentReading.add(charText);
        layer2.batchDraw();

        const fadeIn: Konva.Tween = new Konva.Tween({
          node: charText,
          duration: 0.5,
          opacity: 1,
        });
        setTimeout(() => fadeIn.play(), delay);

        x += charText.width();
        delay += 200;
      });
    });
  }

  // when a char is moused-over, highlight the chars of all related segments
  const charMouseover = (charText) => {
    segmentsForChar(charText).forEach(segment => {
      segmentEachChar(segment, (charInSegment) => {
        if (charIsSelected(charInSegment)) {
          return;
        }
        charInSegment.setAttrs(constants.characterStates.highlighted);
        state.highlightedChars.push(charInSegment);
      });
    });

    layer2.batchDraw();
  }

  // when mouse leaves char, fade the chars of all related segments again
  const charMouseleave = (charText) => {
    state.highlightedChars.forEach(char => {
      if (charIsSelected(char) || char.name().match('rhyme')) {
        return;
      }

      char.setAttrs(constants.characterStates.faded);
    });

    state.highlightedChars = [];

    layer2.batchDraw();
  }

  // when char is clicked, identify the appropriate segment and add it to the
  // current reading
  const charClick = (charText) => {
    if (charText.name().match('rhyme')) {
      return;
    }

    const possibleSegments: any[] = segmentsForChar(charText);
    if (possibleSegments.length === 0) {
      return;
    }

    // if no segment selected: select the first one
    if (!charIsSelected(charText)) {
      if (state.selectedSegmentIds.length === 4) {
        return;
      }

      const segment: any = possibleSegments[0];

      state.selectedSegmentIds.push(segment.id);

      segmentEachChar(segment, (charInSegment) => {
        charInSegment.setAttrs(constants.characterStates.selected);
      });
    } else {
      // else: a segment is selected
      // which of the char's segments is selected?
      const currentSegmentIndex: number = possibleSegments.findIndex(segment => {
        return state.selectedSegmentIds.includes(segment.id);
      });

      const currentSegment: any = possibleSegments[currentSegmentIndex];

      // either way, clear current segment
      segmentEachChar(currentSegment, (charInSegment) => {
        const otherSelectedSegmentForChar: any = segmentsForChar(charInSegment).find(segment => {
          const isAnotherSegment: boolean = (segment.id !== currentSegment.id);
          const isSelected: boolean = state.selectedSegmentIds.includes(segment.id);

          return isAnotherSegment && isSelected;
        });

        const safeToReset: boolean = (otherSelectedSegmentForChar === undefined);

        if (!safeToReset) {
          return;
        }

        resetCharacterState(charInSegment);
      });

      // in case the first is selected, advance to the second segment
      if (currentSegmentIndex === 0) {
        const nextSegment: any = possibleSegments[1];

        const position: number = state.selectedSegmentIds.indexOf(currentSegment.id);
        state.selectedSegmentIds[position] = nextSegment.id;

        segmentEachChar(nextSegment, (charInSegment) => {
          charInSegment.setAttrs(constants.characterStates.selected);
        });
      } else if (currentSegmentIndex === 1) {
        // in case the second is selected, unselect it
        const position: number = state.selectedSegmentIds.indexOf(currentSegment.id);
        state.selectedSegmentIds.splice(position, 1);
      }
    }

    updateCurrentReading();

    const lineCount: number = state.selectedSegmentIds.length;
    if (lineCount === 4) {
      setInstructionText('complete');
      playCurrentReading();
    } else if (lineCount === 0) {
      setInstructionText('unselected');
    } else {
      setInstructionText('selected');
    }

    layer2.batchDraw();
  }

  const getCenterX = (character) => {
    return character.x() + (characterWidth / 2);
  }
  const getCenterY = (character) => {
    return character.y() + (characterHeight / 2);
  }

  let lastFocusedCharacter: Konva.Text, lastLine: Konva.Line;

  const updateFocusText = (characterText) => {
    focusText.text(characterText.text());
    focusText.fill(characterText.fill());
  }

  const updateTrace = (characterText) => {
    if (!lastFocusedCharacter) { return }

    const { color, strokeWidth, fadeDuration } = constants.trace; // check destructuring

    // make new line
    let newLine: Konva.Line = new Konva.Line({
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
      let oldLine: Konva.Line = lastLine;
      let tween: Konva.Tween = new Konva.Tween({
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
    let fadeIn: Konva.Tween = new Konva.Tween({
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

let data: any;

$.when(
  $.ajax({
    url: '/characters.json'
  }),
  $.ajax({
    url: '/segments.json'
  }),
  $.ajax({
    url: '/readings.json'
  })
).then((charactersResponse, segmentsResponse, readingsResponse) => {
  data = {
    characters: charactersResponse[0]["characters"],
    segments: segmentsResponse[0]["segments"],
    readings: segmentsResponse[0]["readings"]
  };
  render(data);
  // $('.footer').show();
});
