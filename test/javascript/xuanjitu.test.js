import Xuanjitu from 'lib/xuanjitu';

describe('::createCharacterGrid', () => {
  test('it returns a 2d array with correct dimensions', () => {
    const result = Xuanjitu.createCharacterGrid();

    expect(result.length).toBe(29);
    expect(result[0].length).toBe(29);
    expect(result[0][0]).toBeUndefined();
  });
});
