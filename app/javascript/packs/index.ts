import Konva from 'konva';
import constants from './constants';

let characterGrid: Konva.Text[][] = new Array(29);
for (let y = 0; y < characterGrid.length; y++) { // check for loops
  characterGrid[y] = new Array(29);
}

const render = ({ characters, segments, readings }) => {
  let state: any = {
    demo: {
      currentReading: {
        index: 0,
        length: 0,
      },
      currentSidebarGroup: undefined,
      highlightedChars: [],
    }
  };

  let stage: Konva.Stage = new Konva.Stage({
    container: 'container',   // id of container <div>
    width: constants.stage.width,
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

  let gridBackground: Konva.Rect = new Konva.Rect({
    x: 0,
    y: 0,
    strokeWidth: 5,
    fill: constants.background.color,
    width: constants.background.width,
    height: constants.background.height,
  });
  layer0.add(gridBackground);


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

  state.demo.currentSidebarGroup = new Konva.Group({
    x: gridBackground.width() + constants.readingText.marginLeft,
    y: constants.readingText.y,
  });

  layer2.add(state.demo.currentSidebarGroup);

  const playSegment = (segment, idx) => {
    const { delayPerChar, duration, opacity } = constants.demo.fadeIn;
    const delayOffset: number = segment.length * idx * delayPerChar;
    let delay: number = delayOffset;
    let charCount: number = 0;

    const sidebarY: number = idx * constants.readingText.lineHeight;
    let sidebarX: number = 0;

    segmentEachChar(segment, char => {
      let isRepeatChar: boolean = false;

      // show char in grid unless already shown
      if (state.demo.highlightedChars.includes(char)) {
        isRepeatChar = true;
      } else {
        state.demo.highlightedChars.push(char);

        const fadeInGrid: Konva.Tween = new Konva.Tween({
          node: char,
          duration: duration,
          opacity: opacity
        });
      }

      // show char in sidebar
      const sidebarChar: Konva.Text = new Konva.Text({
        x: sidebarX,
        y: sidebarY,
        text: char.text(),
        fontFamily: constants.readingText.fontFamily,
        fontSize: constants.readingText.fontSize,
        fill: constants.characters.colorMappings[segment.color],
        opacity: 0,
        segmentId: segment.id,
      });

      state.demo.currentSidebarGroup.add(sidebarChar);
      layer2.batchDraw();

      const fadeInSidebar: Konva.Tween = new Konva.Tween({
        node: sidebarChar,
        duration: duration,
        opacity: opacity,
      });


      // set both
      setTimeout(
        () => {
          isRepeatChar || fadeInGrid.play();
          fadeInSidebar.play();

          // if it's the last char of the last segment, play the next reading
          charCount += 1;
          const isLastSegment: boolean = (idx + 1) == state.demo.currentReading.length;
          const isLastChar: boolean = charCount == segment.length;
          if (isLastSegment && isLastChar) {
            setTimeout(playNextReading, duration * 1000 * 2);
          }
        },
        delay
      );

      // update variables
      sidebarX += sidebarChar.width();
      delay += delayPerChar;
    });
  }

  const playReading = (idx) => {
    if (readings[idx] === undefined) {
      return;
    }

    const { currentReading, currentSidebarGroup, highlightedChars } = state.demo;
    const reading = readings[idx];

    // update state
    currentReading.idx = idx;
    currentReading.length = reading.length;

    // clean up grid
    highlightedChars.forEach(char => {
      char.setAttrs({ opacity: constants.demo.fadeOut.opacity });
    });
    state.demo.highlightedChars = [];

    // clean up sidebar
    const oldTexts: any = currentSidebarGroup.getChildren();
    currentSidebarGroup.removeChildren();
    oldTexts.each(text => text.destroy());

    // play reading in grid and sidebar
    reading.segment_ids.forEach((segmentId, segmentIdx) => {
      const segment: any = segments[segmentId];
      playSegment(segment, segmentIdx);
    });
  }

  const playNextReading = () => {
    playReading(state.demo.currentReading.idx + 1);
  }

  const playReadings = () => {
    playReading(0);
  }

  const playDemo = () => {
    const { duration, opacity } = constants.demo.fadeOut;

    // fade out all characters
    characterTexts.forEach(characterText => {
      const fadeOut: Konva.Tween = new Konva.Tween({
        node: characterText,
        duration: duration,
        opacity: opacity
      });

      fadeOut.play();
    });

    setTimeout(playReadings, duration * 1000);
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

  });

  layers.forEach(layer => {
    stage.add(layer);
    layer.draw();
  });

  setTimeout(playDemo, constants.fadeIn.maxDuration * 1000);
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
    readings: readingsResponse[0]["readings"]
  };
  render(data);
  // $('.footer').show();
});
