import Konva from 'konva';
import constants from './constants';
import { SegmentData } from './interfaces';
import Character from './character';
import Xuanjitu from './xuanjitu';

class Segment {
  readonly id: number;
  readonly length: number;
  readonly color: string;
  readonly characters: Character[];

  readonly head: {
    x: number;
    y: number;
  }

  readonly tail: {
    x: number;
    y: number;
  }

  static createSegments(segmentsData: SegmentData[], grid: Character[][]): any {
    const segments = {};

    segmentsData.forEach((segmentData: SegmentData) => {
      const segment: Segment = new Segment(segmentData);
      segments[segmentData.id] = segment;
      segment.populateCharacters(grid);
    });

    return segments;
  }

  constructor(segmentData: SegmentData) {
    const { id, head_x, head_y, tail_x, tail_y, length, color } = segmentData;

    this.id = id;
    this.head = { x: head_x, y: head_y };
    this.tail = { x: tail_x, y: tail_y };
    this.length = length;
    this.color = color;
    this.characters = [];
  }

  public play(lineNumber: number, isLastSegment: boolean, xjt: Xuanjitu): void {
    const { delayPerChar, duration }: { delayPerChar: number, duration: number } = constants.demo.fadeIn;
    const delayOffset: number = this.length * lineNumber * delayPerChar;

    const sidebarY: number = lineNumber * constants.readingText.lineHeight;
    let sidebarX: number = 0;

    this.characters.forEach((character: Character, index: number) => {
      let isRepeatChar: boolean = false;
      let fadeInGrid: Konva.Tween;

      // prep grid fade-in
      if (xjt.isHighlighted(character)) {
        isRepeatChar = true;
      } else {
        xjt.highlight(character);
        fadeInGrid = Character.createFadeInTween(character.node);
      }

      // prep sidebar fade-in
      const sidebarChar: Konva.Text = character.createSidebarNode(sidebarX, sidebarY);
      xjt.addSidebarNode(sidebarChar);
      const fadeInSidebar: Konva.Tween = Character.createFadeInTween(sidebarChar);

      const delay: number = delayOffset + (delayPerChar * index);

      // set both
      setTimeout(
        () => {
          if (!isRepeatChar) { fadeInGrid.play(); }
          fadeInSidebar.play();

          // if it's the last char of the last segment, play the next reading
          const isLastChar: boolean = index === (this.length - 1);
          if (isLastSegment && isLastChar) {
            setTimeout(xjt.continueRun.bind(xjt), duration * 1000 * 2);
          }
        },
        delay,
      );

      // update variables
      sidebarX += sidebarChar.width();
    });
  }

  private populateCharacters(grid: Character[][]): void {
    const getCharAtCoordinates = (x: number, y: number): Character => {
      return grid[y][x];
    };

    if (this.isVertical()) {
      let y: number = this.head.y;
      while (y !== this.tail.y) {
        this.characters.push(getCharAtCoordinates(this.head.x, y));
        y += (this.head.y < this.tail.y) ? 1 : -1;
      }
      this.characters.push(getCharAtCoordinates(this.tail.x, this.tail.y));
    } else if (this.isHorizontal()) {
      let x: number = this.head.x;
      while (x !== this.tail.x) {
        this.characters.push(getCharAtCoordinates(x, this.head.y));
        x += (this.head.x < this.tail.x) ? 1 : -1;
      }
      this.characters.push(getCharAtCoordinates(this.tail.x, this.tail.y));
    } else {
      // diagonal segment
    }
  }

  private isHorizontal(): boolean {
    return (this.head.y === this.tail.y) && (this.head.x !== this.tail.x);
  }

  private isVertical(): boolean {
    return (this.head.x === this.tail.x) && (this.head.y !== this.tail.y);
  }
}

export default Segment;
