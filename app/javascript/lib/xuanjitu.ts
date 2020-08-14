import Konva from 'konva';
import constants from './constants';
import { CharacterData, State } from './interfaces';
import Character from './character';
import Reading from './reading';
import Segment from './segment';

class Xuanjitu {
  private readonly characterGrid: Character[][];
  private characters: Character[];
  private readonly gridBackground: Konva.Rect;
  private readonly layers: Konva.Layer[];
  private readonly readings: Reading[];
  private readonly segments: { [index: number]: Segment; };
  private readonly sidebarGroup: Konva.Group;
  private readonly stage: Konva.Stage;
  private state: State;

  static createCharacterGrid(): Character[][] {
    const characterGrid: Character[][] = new Array(29);
    for (let y: number = 0; y < characterGrid.length; y += 1) {
      characterGrid[y] = new Array(29);
    }
    return characterGrid;
  }

  static createGridBackground(): Konva.Rect {
    const { color, width, height, strokeWidth }:
      { color: string, width: number, height: number, strokeWidth: number } = constants.background;

    return new Konva.Rect({
      width,
      height,
      strokeWidth,
      x: 0,
      y: 0,
      fill: color,
    });
  }

  static createLayers(): Konva.Layer[] {
    const layers: Konva.Layer[] = [new Konva.Layer(), new Konva.Layer()];
    layers.forEach(layer => { layer.listening(false); });

    return layers;
  }

  static createSidebarGroup(offsetX: number): Konva.Group {
    const { marginLeft, y }: { marginLeft: number, y: number } = constants.readingText;

    return new Konva.Group({
      y,
      x: offsetX + marginLeft,
    });
  }

  static createStage(): Konva.Stage {
    return new Konva.Stage({
      container: 'container', // id of container <div>
      width: constants.stage.width,
      height: constants.stage.height,
    });
  }

  static createState(): State {
    return {
      demo: {
        currentReading: undefined,
        highlightedChars: [],
      },
    };
  }

  constructor({ characters, segments, readings }) {
    this.state = Xuanjitu.createState();
    this.characterGrid = Xuanjitu.createCharacterGrid();
    this.stage = Xuanjitu.createStage();
    this.layers = Xuanjitu.createLayers();

    this.gridBackground = Xuanjitu.createGridBackground();
    this.layers[0].add(this.gridBackground);

    this.sidebarGroup = Xuanjitu.createSidebarGroup(this.gridBackground.width());
    this.layers[1].add(this.sidebarGroup);

    this.initializeChars(characters);

    this.segments = Segment.createSegments(segments, this.characterGrid);
    this.readings = Reading.createReadings(readings, this.segments);
  }

  public run(): void {
    const { delay, maxDuration }: { delay: number, maxDuration: number } = constants.fadeIn;

    setTimeout(this.render.bind(this), delay * 1000);
    setTimeout(this.playDemo.bind(this), maxDuration * 1000);
  }

  public addSidebarNode(node: any): void {
    this.sidebarGroup.add(node);
    this.layers[1].batchDraw();
  }

  public isHighlighted(character: Character): boolean {
    return this.state.demo.highlightedChars.includes(character);
  }

  public highlight(character: Character): void {
    this.state.demo.highlightedChars.push(character);
  }

  public continueRun(): void {
    this.playNextReading();
  }

  private initializeChars(characters: CharacterData[]): void {
    // set character Text objects to the grid
    this.characters = characters.map((characterData: CharacterData): Character => {
      const newCharacter = new Character(characterData);
      this.characterGrid[newCharacter.y][newCharacter.x] = newCharacter;
      this.layers[1].add(newCharacter.node);

      return newCharacter;
    });
  }

  private fadeInChars(): void {
    this.characters.forEach((character: Character): void => {
      character.initialFadeIn();
    });
  }

  private playDemo(): void {
    this.characters.forEach((character: Character) => {
      character.fadeOut();
    });

    const delay: number = constants.demo.fadeOut.duration;
    setTimeout(this.playReadings.bind(this), delay * 1000);
  }

  private playReadings(): void {
    this.playReading(this.readings[0]);
  }

  private playReading(reading: Reading) {
    // update state
    this.state.demo.currentReading = reading;

    // clean up grid
    this.characters.forEach((character: Character) => { character.hide(); });
    this.state.demo.highlightedChars = [];

    // clean up sidebar
    const oldNodes: any = this.sidebarGroup.getChildren();
    this.sidebarGroup.removeChildren();

    reading.play(this);
  }

  private playNextReading(): void {
    const nextIndex: number = this.state.demo.currentReading.index + 1;
    const nextReading: Reading = this.readings[nextIndex] || this.readings[0];

    this.playReading(nextReading);
  }

  private render(): void {
    this.layers.forEach((layer: Konva.Layer): void => {
      this.stage.add(layer);
      layer.draw();
    });

    this.fadeInChars();
  }
}

export default Xuanjitu;
