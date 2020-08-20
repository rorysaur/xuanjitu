import Character from 'lib/character';

describe('constructor', () => {
  const text = '心';
  const x = 3;
  const y = 4;
  const color = 'red';

  const characterData = {
    text,
    color,
    form: 'simplified',
    x_coordinate: x,
    y_coordinate: y,
    rhyme: true,
    segment_ids: [],
  };

  beforeAll(() => {
    Character.createNode = jest.fn(() => {
      return { opacity: jest.fn() };
    });
  });

  test('it returns an instance of Character with the expected attributes', () => {
    const result = new Character(characterData);

    expect(result).toBeInstanceOf(Character);

    expect(result.text).toEqual(text);
    expect(result.x).toEqual(x);
    expect(result.y).toEqual(y);
    expect(result.color).toEqual(color);
  });

  test('it calls Character.createNode', () => {
    const result = new Character(characterData);

    expect(Character.createNode).toHaveBeenCalledWith(characterData);
  });
});
