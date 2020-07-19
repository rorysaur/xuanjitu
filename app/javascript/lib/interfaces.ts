import Konva from 'konva';
import Character from './character';
import Reading from './reading';

interface CharacterData {
  readonly text: string;
  readonly form: string;
  readonly x_coordinate: number;
  readonly y_coordinate: number;
  readonly color: string;
  readonly rhyme: boolean;
  readonly segment_ids: number[];
}

interface ReadingData {
  readonly id: number;
  readonly color: string;
  readonly block_number: number;
  readonly number: number;
  readonly length: number;
  readonly segment_ids: number[];
}

interface SegmentData {
  readonly id: number;
  readonly head_x: number;
  readonly head_y: number;
  readonly tail_x: number;
  readonly tail_y: number;
  readonly length: number;
  readonly color: string;
}

interface State {
  demo: {
    currentReading: Reading;
    highlightedChars: Character[];
  }
}

export {
  CharacterData,
  ReadingData,
  SegmentData,
  State,
}
