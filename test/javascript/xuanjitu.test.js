import { createCharacterGrid, getCharsInSegment } from 'lib/xuanjitu';

describe('createCharacterGrid', () => {
  test('it returns a 2d array with correct dimensions', () => {
    const result = createCharacterGrid();

    expect(result.length).toBe(29);
    expect(result[0].length).toBe(29);
    expect(result[0][0]).toBeUndefined();
  });
});

describe('getCharsInSegment', () => {
  let grid;
  let segment;
  let expected;

  const chars = ['a', 'b', 'c', 'd', 'e', 'f', 'g'];

  const createTextMock = (idx) => {
    return { text: chars[idx] };
  };

  beforeEach(() => {
    grid = createCharacterGrid();
  });

  describe('for horizontal segment', () => {
    const left_coordinate = 0;
    const right_coordinate = 6;
    const y = 0;

    beforeEach(() => {
      // prep the grid
      for (let x = left_coordinate; x <= right_coordinate; x += 1) {
        grid[y][x] = createTextMock(x);
      }
    });

    describe ('left to right', () => {
      beforeEach(() => {
        // prep the segment
        segment = {
          id: 1,
          head_x: left_coordinate,
          head_y: y,
          tail_x: right_coordinate,
          tail_y: y,
          length: 7,
          color: 'red',
        };

        // prep the expected array
        expected = chars.map(char => { return { text: char }; });
      });

      test('it returns the expected array', () => {
        const result = getCharsInSegment(segment, grid);

        expect(result).toEqual(expected);
      });
    });

    describe ('right to left', () => {
      beforeEach(() => {
        // prep the segment
        segment = {
          id: 1,
          head_x: right_coordinate,
          head_y: y,
          tail_x: left_coordinate,
          tail_y: y,
          length: 7,
          color: 'red',
        };

        // prep the expected array
        expected = chars.reverse().map(char => { return { text: char }; });
      });

      test('it returns the expected array', () => {
        const result = getCharsInSegment(segment, grid);

        expect(result).toEqual(expected);
      });
    });
  });

  describe('for vertical segment', () => {
    let segment;
    let expected;

    const top_coordinate = 0;
    const bottom_coordinate = 6;
    const x = 0;

    beforeEach(() => {
      // prep the grid
      for (let y = top_coordinate; y <= bottom_coordinate; y += 1) {
        grid[y][x] = createTextMock(y);
      }
    });

    describe('top to bottom', () => {
      beforeEach(() => {
        // prep the segment
        segment = {
          id: 1,
          head_x: x,
          head_y: top_coordinate,
          tail_x: x,
          tail_y: bottom_coordinate,
          length: 7,
          color: 'red',
        };

        // prep the expected array
        expected = chars.map(char => { return { text: char }; });
      });

      test('it returns the expected array', () => {
        const result = getCharsInSegment(segment, grid);

        expect(result).toEqual(expected);
      });
    });

    describe('bottom to top', () => {
      beforeEach(() => {
        // prep the segment
        segment = {
          id: 1,
          head_x: x,
          head_y: bottom_coordinate,
          tail_x: x,
          tail_y: top_coordinate,
          length: 7,
          color: 'red',
        };

        // prep the expected array
        expected = chars.reverse().map(char => { return { text: char }; });
      });

      test('it returns the expected array', () => {
        const result = getCharsInSegment(segment, grid);

        expect(result).toEqual(expected);
      });
    });
  });
});
