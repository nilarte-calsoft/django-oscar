import Detector from '../Detector';
export default class CamelCaseDetector extends Detector {
    constructor(probability: number);
    scan(line: string): number;
}
