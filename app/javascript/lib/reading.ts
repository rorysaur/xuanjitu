import Konva from 'konva';
import constants from './constants';
import { ReadingData } from './interfaces';
import Segment from './segment';
import Xuanjitu from './xuanjitu';

class Reading {
  readonly id: number;
  readonly color: string;
  readonly blockNumber: number;
  readonly readingNumber: number;
  readonly length: number;
  readonly index: number;
  segments: Segment[];

  static createReadings(readingsData: ReadingData[], segments: any): Reading[] {
    return readingsData.map((readingData: ReadingData, index: number): Reading => {
      const reading: Reading = new Reading(readingData, index);
      reading.populateSegments(readingData.segment_ids, segments);
      return reading;
    });
  }

  constructor(readingData: ReadingData, index: number) {
    const { id, color, block_number, length } = readingData;

    this.id = id;
    this.color = color;
    this.blockNumber = block_number;
    this.length = length;
    this.index = index;
    this.readingNumber = readingData.number;
  }

  public play(xjt: Xuanjitu): void {
    this.segments.forEach((segment: Segment, index: number) => {
      const isLastSegment: boolean = index === (this.length - 1);
      segment.play(index, isLastSegment, xjt);
    });
  }

  private populateSegments(segmentIds: number[], segments: Segment[]) {
    this.segments = segmentIds.map((segmentId: number) => {
      return segments[segmentId];
    });
  }
}

export default Reading;
