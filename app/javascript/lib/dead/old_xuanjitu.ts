// @ts-nocheck

import Konva from 'konva';
import constants from './constants';
import { CharacterData, ReadingData, SegmentData, SegmentsData, State } from './interfaces';

// pure functions

const createCharacterGrid = (): Konva.Text[][] => {
  const characterGrid: Konva.Text[][] = new Array(29);
  for (let y: number = 0; y < characterGrid.length; y += 1) {
    characterGrid[y] = new Array(29);
  }
  return characterGrid;
};

const createCharacterText = (character: CharacterData): Konva.Text => {
  const { width, height, colorMappings, fontSize, fontFamily, strokeWidth }:
    { width: number, height: number, colorMappings: object, fontSize: number, fontFamily: string, strokeWidth: number }
    = constants.characters;
  const { offset }: { offset: any } = constants.text;

  return new Konva.Text({
    fontFamily,
    fontSize,
    strokeWidth,
    character,
    x: (character.x_coordinate * width) + offset.x,
    y: (character.y_coordinate * height) + offset.y,
    text: character.text,
    fill: colorMappings[character.color],
  });
};

const createFadeInTween = (node: Konva.Text): Konva.Tween => {
  const { duration, opacity }: { duration: number, opacity: number } = constants.demo.fadeIn;

  return new Konva.Tween({
    node,
    duration,
    opacity,
  });
};

const createGridBackground = (): Konva.Rect => {
  const { color, width, height, strokeWidth }:
    { color: string, width: number, height: number, strokeWidth: number }
    = constants.background;

  return new Konva.Rect({
    width,
    height,
    strokeWidth,
    x: 0,
    y: 0,
    fill: color,
  });
};

const createLayers = (): Konva.Layer[] => {
  return [new Konva.Layer(), new Konva.Layer()];
};

const createSidebarGroup = (offsetX: number): Konva.Group => {
  const { marginLeft, y }: { marginLeft: number, y: number } = constants.readingText;

  return new Konva.Group({
    y,
    x: offsetX + marginLeft,
  });
};

const createStage = (): Konva.Stage => {
  return new Konva.Stage({
    container: 'container', // id of container <div>
    width: constants.stage.width,
    height: constants.stage.height,
  });
};

const createState = (): State => {
  return {
    demo: {
      currentReading: {
        index: 0,
        length: 0,
      },
      currentSidebarGroup: undefined,
      highlightedChars: [],
    },
  };
};

const getCharsInSegment = (segment: SegmentData, grid: Konva.Text[][]): Konva.Text[] => {
  const { head_x, tail_x, head_y, tail_y }:
    { head_x: number, tail_x: number, head_y: number, tail_y: number }
    = segment;

  const chars: Konva.Text[] = [];

  const getCharAtCoordinates = (x: number, y: number): Konva.Text => {
    return grid[y][x];
  };

  if (head_x === tail_x) {
    // vertical segment
    let y: number = head_y;
    while (y !== tail_y) {
      chars.push(getCharAtCoordinates(head_x, y));
      y += (head_y < tail_y) ? 1 : -1;
    }
    chars.push(getCharAtCoordinates(tail_x, tail_y));
  } else if (head_y === tail_y) {
    // horizontal segment
    let x: number = head_x;
    while (x !== tail_x) {
      chars.push(getCharAtCoordinates(x, head_y));
      x += (head_x < tail_x) ? 1 : -1;
    }
    chars.push(getCharAtCoordinates(tail_x, tail_y));
  } else {
    // diagonal segment
  }

  return chars;
};

// end pure functions

const render = ({ characters, segments, readings }: { characters: CharacterData[], segments: SegmentsData, readings: ReadingData[] }) => {
  const state: State = createState();
  const characterGrid: Konva.Text[][] = createCharacterGrid();
  const stage: Konva.Stage = createStage();
  const layers: Konva.Layer[] = createLayers();

  // set character Text objects to the grid
  const characterTexts: Konva.Text[] = characters.map((character: CharacterData): Konva.Text => {
    const newText: Konva.Text = createCharacterText(character);
    characterGrid[character.y_coordinate][character.x_coordinate] = newText;

    return newText;
  });

  const gridBackground: Konva.Rect = createGridBackground();
  layers[0].add(gridBackground);

  state.demo.currentSidebarGroup = createSidebarGroup(gridBackground.width());
  layers[1].add(state.demo.currentSidebarGroup);

  const playSegment = (segment: SegmentData, idx: number) => {
    const { delayPerChar, duration }: { delayPerChar: number, duration: number } = constants.demo.fadeIn;
    const delayOffset: number = segment.length * idx * delayPerChar;
    let delay: number = delayOffset;
    let charCount: number = 0;

    const sidebarY: number = idx * constants.readingText.lineHeight;
    let sidebarX: number = 0;

    // get chars in segment: pass it a grid
    const chars: Konva.Text[] = getCharsInSegment(segment, characterGrid);

    chars.forEach((char: Konva.Text) => {
      let isRepeatChar: boolean = false;
      let fadeInGrid: Konva.Tween;

      // show char in grid unless already shown
      if (state.demo.highlightedChars.includes(char)) {
        isRepeatChar = true;
      } else {
        state.demo.highlightedChars.push(char);
        fadeInGrid = createFadeInTween(char);
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
      layers[1].batchDraw();

      const fadeInSidebar: Konva.Tween = createFadeInTween(sidebarChar);

      // set both
      setTimeout(
        () => {
          if (!isRepeatChar) { fadeInGrid.play(); }
          fadeInSidebar.play();

          // if it's the last char of the last segment, play the next reading
          charCount += 1;
          const isLastSegment: boolean = (idx + 1) === state.demo.currentReading.length;
          const isLastChar: boolean = charCount === segment.length;
          if (isLastSegment && isLastChar) {
            setTimeout(playNextReading, duration * 1000 * 2);
          }
        },
        delay,
      );

      // update variables
      sidebarX += sidebarChar.width();
      delay += delayPerChar;
    });
  };

  const playReading = (idx: number) => {
    const { currentReading, currentSidebarGroup, highlightedChars }:
      { currentReading: any, currentSidebarGroup: Konva.Group, highlightedChars: Konva.Text[] }
      = state.demo;
    const reading: ReadingData = readings[idx];

    // update state
    currentReading.index = idx;
    currentReading.length = reading.length;

    // clean up grid
    highlightedChars.forEach(char => {
      char.setAttrs({ opacity: constants.demo.fadeOut.opacity });
    });
    state.demo.highlightedChars = [];

    // clean up sidebar
    const oldTexts: any = currentSidebarGroup.getChildren();
    currentSidebarGroup.removeChildren();
    oldTexts.each(text => { text.destroy(); });

    // play reading in grid and sidebar
    reading.segment_ids.forEach((segmentId: number, segmentIdx: number) => {
      const segment: SegmentData = segments[segmentId];
      playSegment(segment, segmentIdx);
    });
  };

  const playNextReading = (): void => {
    const nextIdx: number = state.demo.currentReading.index + 1;

    if (readings[nextIdx] === undefined) {
      playReading(0);
    } else {
      playReading(state.demo.currentReading.index + 1);
    }
  };

  const playReadings = (): void => {
    playReading(0);
  };

  const playDemo = () => {
    const { duration, opacity }: { duration: number, opacity: number } = constants.demo.fadeOut;

    // fade out all characters
    characterTexts.forEach(characterText => {
      const fadeOut: Konva.Tween = new Konva.Tween({
        duration,
        opacity,
        node: characterText,
      });

      fadeOut.play();
    });

    setTimeout(playReadings, duration * 1000);
  };

  const initializeChars = (): void => {
    characterTexts.forEach(characterText => {
      layers[1].add(characterText);

      // fade in text
      characterText.opacity(0);

      const fadeIn: Konva.Tween = new Konva.Tween({
        node: characterText,
        duration: Math.random() * constants.fadeIn.maxDuration,
        opacity: 1,
      });

      fadeIn.play();
    });
  };

  layers.forEach(layer => {
    stage.add(layer);
    layer.draw();
  });

  initializeChars();

  setTimeout(playDemo, constants.fadeIn.maxDuration * 1000);
};

export { createCharacterGrid, getCharsInSegment, render };
