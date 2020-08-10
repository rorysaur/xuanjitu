import Xuanjitu from '../lib/xuanjitu';

let data: any;

$.when(
  $.ajax({
    url: '/characters.json',
  }),
  $.ajax({
    url: '/segments.json',
  }),
  $.ajax({
    url: '/readings.json',
  })
).then((charactersResponse, segmentsResponse, readingsResponse) => {
  data = {
    characters: charactersResponse[0]['characters'],
    segments: segmentsResponse[0]['segments'],
    readings: readingsResponse[0]['readings'],
  };
  const xjt: Xuanjitu = new Xuanjitu(data);
  xjt.run();
});
