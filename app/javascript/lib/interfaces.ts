import Konva from 'konva';

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

interface SegmentsData {
  readonly [index: number]: SegmentData;
}

interface State {
  demo: {
    currentReading: {
      index: number;
      length: number;
    }
    currentSidebarGroup: undefined | Konva.Group;
    highlightedChars: Konva.Text[];
  }
}

export {
  CharacterData,
  ReadingData,
  SegmentData,
  SegmentsData,
  State,
}
