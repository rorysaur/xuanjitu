import Konva from 'konva';
import constants from './constants';
import { CharacterData } from './interfaces';

class Character {
  readonly node: Konva.Text;
  readonly text: string;
  readonly x: number;
  readonly y: number;
  readonly color: string;

  static createFadeInTween(node: Konva.Text): Konva.Tween {
    const { duration, opacity }: { duration: number, opacity: number } = constants.demo.fadeIn;

    return new Konva.Tween({
      node,
      duration,
      opacity,
    });
  }

  static createNode(character: CharacterData): Konva.Text {
    const { width, height, colorMappings, fontSize, fontFamily, strokeWidth }:
      { width: number, height: number, colorMappings: object, fontSize: number, fontFamily: string, strokeWidth: number } = constants.characters;
    const { offset }: { offset: any } = constants.text;

    return new Konva.Text({
      fontFamily,
      fontSize,
      strokeWidth,
      character,
      x: (character.x_coordinate * width) + offset.x,
      y: (character.y_coordinate * height) + offset.y,
      text: character.text,
      fill: colorMappings[character.color],
    });
  }

  constructor(characterData: CharacterData) {
    const { text, color, x_coordinate, y_coordinate } = characterData;

    this.text = text;
    this.color = color;
    this.x = x_coordinate;
    this.y = y_coordinate;

    this.node = Character.createNode(characterData);
  }

  public fadeIn(): void {
    this.node.opacity(0);

    const fadeIn: Konva.Tween = new Konva.Tween({
      node: this.node,
      duration: Math.random() * constants.fadeIn.maxDuration,
      opacity: 1,
    });

    fadeIn.play();
  }

  public fadeOut(): void {
    const { duration, opacity }: { duration: number, opacity: number } = constants.demo.fadeOut;

    const fadeOut: Konva.Tween = new Konva.Tween({
      duration,
      opacity,
      node: this.node,
    });

    fadeOut.play();
  }

  public hide(): void {
    this.node.setAttrs({ opacity: constants.demo.fadeOut.opacity });
  }

  public createSidebarNode(x: number, y: number): Konva.Text {
    return new Konva.Text({
      x,
      y,
      text: this.text,
      fontFamily: constants.readingText.fontFamily,
      fontSize: constants.readingText.fontSize,
      fill: constants.characters.colorMappings[this.color],
      opacity: 0,
    });
  }
}

export default Character;
