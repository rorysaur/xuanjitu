import { render } from '../lib/xuanjitu';

$('.footer').hide();

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
  render(data);
  // $('.footer').show();
});
