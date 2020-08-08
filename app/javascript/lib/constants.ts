const constants = {
  background: {
    width: 750,
    height: 750,
    color: '#eee',
    strokeWidth: 5
  },
  // buttons: {
  //   marginLeft: 20,
  //   y: 30,
  // },
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
    }
  },
  demo: {
    fadeIn: {
      delayPerChar: 300,
      duration: 0.5,
      opacity: 1
    },
    fadeOut: {
      duration: 1,
      opacity: 0.2
    }
  },
  fadeIn: {
    maxDuration: 6,
  },
  // focusText: {
  //   marginLeft: 20,
  //   fontSize: 200,
  //   y: 500
  // },
  // instructionText: {
  //   marginLeft: 20,
  //   y: 100,
  // },
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
    }
  },
  stage: {
    height: 1200,
    width: 1200
  },
  text: {
    offset: {
      x: 10,
      y: 10,
    }
  },
  // trace: {
  //   color: "#999",
  //   strokeWidth: 2,
  //   fadeDuration: 1,
  // }
};

export default constants;
