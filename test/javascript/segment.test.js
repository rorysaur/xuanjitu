// import Character from 'lib/character';
import Segment from 'lib/segment';
import Xuanjitu from 'lib/xuanjitu';

describe('constructor', () => {
  const id = 1;
  const headX = 0;
  const headY = 0;
  const tailX = 0;
  const tailY = 3;
  const length = 4;
  const color = 'purple';

  const segmentData = {
    id,
    length,
    color,
    head_x: headX,
    head_y: headY,
    tail_x: tailX,
    tail_y: tailY,
  };

  test('it returns an instance of Segment with the expected attributes', () => {
    const result = new Segment(segmentData);

    expect(result).toBeInstanceOf(Segment);

    expect(result.id).toEqual(id);
    expect(result.head.x).toEqual(headX);
    expect(result.head.y).toEqual(headY);
    expect(result.tail.x).toEqual(tailX);
    expect(result.tail.y).toEqual(tailY);
    expect(result.length).toEqual(length);
    expect(result.color).toEqual(color);

    expect(result.characters).toEqual([]);
  });
});

describe('createSegments static method', () => {
  let grid;

  const characterMappings = ['a', 'b', 'c'];
  const id = 2;
  const length = 3;
  const color = 'green';

  beforeAll(() => {
    grid = Xuanjitu.createCharacterGrid();
  });

  describe('for a horizontal segment', () => {
    const segmentData = {
      id,
      length,
      color,
      head_x: 0,
      head_y: 0,
      tail_x: 2,
      tail_y: 0,
    };

    beforeAll(() => {
      // populate grid
      for (let i = 0; i < length; i += 1) {
        const x = i;
        const y = 0;

        const characterMock = {
          x,
          y,
          color,
          text: characterMappings[i],
        };

        grid[y][x] = characterMock;
      }
    });

    test('it returns an object with an instance of Segment at the expected index', () => {
      const segments = Segment.createSegments([segmentData], grid);

      expect(segments[id]).toBeInstanceOf(Segment);
    });

    test('it contains an instance of Segment with characters array populated correctly', () => {
      const segments = Segment.createSegments([segmentData], grid);
      const segment = segments[id];
      const segmentCharacterTexts = segment.characters.map(character => { return character.text; });
      const expectedCharacterTexts = ['a', 'b', 'c'];

      expect(segment.characters.length).toEqual(length);
      expect(segmentCharacterTexts).toEqual(expectedCharacterTexts);
    });
  });

  describe('for a vertical segment', () => {
    const segmentData = {
      id,
      length,
      color,
      head_x: 0,
      head_y: 0,
      tail_x: 0,
      tail_y: 2,
    };

    beforeAll(() => {
      // populate grid
      for (let i = 0; i < length; i += 1) {
        const x = 0;
        const y = i;

        const characterMock = {
          x,
          y,
          color,
          text: characterMappings[i],
        };

        grid[y][x] = characterMock;
      }
    });

    test('it returns an object with an instance of Segment at the expected index', () => {
      const segments = Segment.createSegments([segmentData], grid);

      expect(segments[id]).toBeInstanceOf(Segment);
    });

    test('it contains an instance of Segment with characters array populated correctly', () => {
      const segments = Segment.createSegments([segmentData], grid);
      const segment = segments[id];
      const segmentCharacterTexts = segment.characters.map(character => { return character.text; });
      const expectedCharacterTexts = ['a', 'b', 'c'];

      expect(segment.characters.length).toEqual(length);
      expect(segmentCharacterTexts).toEqual(expectedCharacterTexts);
    });
  });

  describe('for diagonal segment', () => {
    const segmentData = {
      id,
      length,
      color,
      head_x: 0,
      head_y: 0,
      tail_x: 2,
      tail_y: 2,
    };

    test('it throws an error', () => {
      const createSegments = () => { Segment.createSegments([segmentData], grid); };
      expect(createSegments).toThrow(/diagonal segment/);
    });
  });

  describe('when character is missing', () => {
    const segmentData = {
      id,
      color,
      head_x: 0,
      head_y: 0,
      tail_x: 5, // segment is longer than the number of characters
      tail_y: 0,
      length: 6,
    };

    beforeAll(() => {
      // populate grid
      for (let i = 0; i < length; i += 1) {
        const x = i;
        const y = 0;

        const characterMock = {
          x,
          y,
          color,
          text: characterMappings[i],
        };

        grid[y][x] = characterMock;
      }
    });

    test('it throws an error', () => {
      const createSegments = () => { Segment.createSegments([segmentData], grid); };
      expect(createSegments).toThrow(/character not found/);
    });
  });
});
