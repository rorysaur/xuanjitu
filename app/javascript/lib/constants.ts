const constants = {
  background: {
    width: 750,
    height: 750,
    color: '#eee',
    strokeWidth: 5,
  },
  characters: {
    width: 25,
    height: 25,
    colorMappings: {
      black: 'black',
      blue: 'blue',
      green: 'green',
      purple: 'purple',
      red: 'red',
      yellow: '#fc0',
    },
    fontSize: 20,
    fontFamily: 'Ma Shan Zheng',
    strokeWidth: 1,
  },
  characterStates: {
    faded: {
      fill: '#999',
      opacity: 0.4,
      characterState: 'faded',
    },
    highlighted: {
      fill: 'red',
      opacity: 0.4,
      characterState: 'highlighted',
    },
    selected: {
      fill: 'red',
      opacity: 1,
      characterState: 'selected',
    },
  },
  demo: {
    fadeIn: {
      delayPerChar: 300, // ms
      delayPerReading: 2000, // ms
      duration: 0.5, // sec
      opacity: 1,
    },
    fadeOut: {
      duration: 1,
      opacity: 0.2,
    },
  },
  fadeIn: {
    delay: 1,
    maxDuration: 7,
  },
  readingText: {
    charWidthMultiplier: 1.5,
    lineHeight: 45,
    marginLeft: 60,
    fontFamily: 'Ma Shan Zheng',
    fontSize: 30,
    rightColumnOffset: 200,
    y: 100,
    pinyin: {
      fontFamily: 'Roboto Mono',
      fontSize: 14,
    },
  },
  stage: {
    height: 750,
    width: 1200,
  },
  text: {
    offset: {
      x: 10,
      y: 10,
    },
  },
};

export default constants;
