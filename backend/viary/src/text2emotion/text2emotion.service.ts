import { Injectable } from '@nestjs/common';
import { execSync } from 'child_process';

@Injectable()
export class Text2emotionService {
    execute(sentence: string) {
        const command = `python3 /home/ubuntu/workspace/Viary/ml/text2emotion.py ${sentence}`
        const out = execSync(command).toString();
        return JSON.parse(out);
    }
}

