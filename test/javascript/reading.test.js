import Reading from 'lib/reading';

describe('constructor', () => {
  const index = 17;
  const id = 2;
  const color = 'green';
  const blockNumber = 3;
  const number = 4;
  const length = 6;

  const readingData = {
    id,
    color,
    number,
    length,
    block_number: blockNumber,
    segment_ids: [],
  };

  test('it returns an instance of Reading with the expected attributes', () => {
    const result = new Reading(readingData, index);

    expect(result).toBeInstanceOf(Reading);

    expect(result.id).toEqual(id);
    expect(result.color).toEqual(color);
    expect(result.blockNumber).toEqual(blockNumber);
    expect(result.readingNumber).toEqual(number);
    expect(result.length).toEqual(length);
    expect(result.index).toEqual(index);
  });
});
