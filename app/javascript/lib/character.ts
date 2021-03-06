import Konva from 'konva';
import constants from './constants';
import { CharacterData } from './interfaces';

class Character {
  readonly node: Konva.Text;
  readonly text: string;
  readonly x: number;
  readonly y: number;
  readonly color: string;
  readonly pinyin: string;
  pinyinNode: Konva.Text;
  sidebarNode: Konva.Text;
  gridTween: Konva.Tween;
  sidebarTween: Konva.Tween;
  pinyinTween: Konva.Tween;

  static createNode(character: CharacterData): Konva.Text {
    const { width, height, colorMappings, fontSize, fontFamily, strokeWidth }:
      { width: number, height: number, colorMappings: object, fontSize: number, fontFamily: string, strokeWidth: number } = constants.characters;
    const { offset }: { offset: any } = constants.text;

    const newNode: Konva.Text = new Konva.Text({
      fontFamily,
      fontSize,
      strokeWidth,
      character,
      x: (character.x_coordinate * width) + offset.x,
      y: (character.y_coordinate * height) + offset.y,
      text: character.text,
      fill: colorMappings[character.color],
    });

    newNode.listening(false);
    newNode.transformsEnabled('position');
    newNode.perfectDrawEnabled(false);

    return newNode;
  }

  static fadeInNode(node: Konva.Text): void {
    const { duration, opacity }: { duration: number, opacity: number } = constants.demo.fadeIn;

    node.to({
      duration,
      opacity,
    });
  }

  constructor(characterData: CharacterData) {
    const { text, color, pinyin, x_coordinate, y_coordinate } = characterData;

    this.text = text;
    this.color = color;
    this.pinyin = pinyin;
    this.x = x_coordinate;
    this.y = y_coordinate;

    this.node = Character.createNode(characterData);
    this.node.opacity(0);
  }

  public initialFadeIn(): void {
    const { delay, maxDuration }: { delay: number, maxDuration: number } = constants.fadeIn;

    this.node.to({
      duration: Math.random() * (maxDuration - delay),
      opacity: 1,
    });
  }

  public fadeIn(): void {
    Character.fadeInNode(this.node);
  }

  public fadeOut(): void {
    const { duration, opacity }: { duration: number, opacity: number } = constants.demo.fadeOut;

    this.node.to({
      duration,
      opacity,
    });
  }

  public hide(): void {
    this.node.setAttrs({ opacity: constants.demo.fadeOut.opacity });
  }

  public getPinyinNodeAt(x: number, y: number): Konva.Text {
    if (this.pinyinNode === undefined) {
      this.pinyinNode = new Konva.Text({
        x,
        y,
        text: this.pinyin,
        fontFamily: constants.readingText.pinyin.fontFamily,
        fontSize: constants.readingText.pinyin.fontSize,
        fill: constants.characters.colorMappings[this.color],
        opacity: 0,
      });
      this.pinyinNode.offsetX(this.pinyinNode.width() / 2);
      this.pinyinNode.listening(false);
      this.pinyinNode.transformsEnabled('position');
      this.pinyinNode.perfectDrawEnabled(false);
    } else {
      this.pinyinNode.setAttrs({ x, y, opacity: 0 });
    }

    return this.pinyinNode;
  }

  public fadeInPinyin(): void {
    Character.fadeInNode(this.pinyinNode);
  }

  public getSidebarNodeAt(x: number, y: number): Konva.Text {
    if (this.sidebarNode === undefined) {
      this.sidebarNode = new Konva.Text({
        x,
        y,
        text: this.text,
        fontFamily: constants.readingText.fontFamily,
        fontSize: constants.readingText.fontSize,
        fill: constants.characters.colorMappings[this.color],
        opacity: 0,
      });
      this.sidebarNode.listening(false);
      this.sidebarNode.transformsEnabled('position');
      this.sidebarNode.perfectDrawEnabled(false);
    } else {
      this.sidebarNode.setAttrs({ x, y, opacity: 0 });
    }

    return this.sidebarNode;
  }

  public fadeInSidebar(): void {
    Character.fadeInNode(this.sidebarNode);
  }
}

export default Character;
