import { Injectable } from '@nestjs/common';
import { execSync } from 'child_process';

@Injectable()
export class Text2emotionService {
  execute(_sentence: string, lang: string) {
    if (!['en', 'ja'].includes(lang)) {
      return JSON.parse('{}');
    }
    let sentence = _sentence;
    sentence = sentence.replace(/\n/g, ". ");
    sentence = sentence.replace(/"/g, "\'");
    if (lang === 'ja') {
      const translationCommand = `/home/ubuntu/workspace/Viary/ml/venv/bin/python /home/ubuntu/workspace/Viary/ml/ja2en.py \"${sentence}\"`;
      sentence = execSync(translationCommand).toString();
      sentence = sentence.replace(/\n/g, ". ");
      sentence = sentence.replace(/"/g, "\'");
    }
    console.log(sentence);
    const command = `/home/ubuntu/workspace/Viary/ml/venv/bin/python /home/ubuntu/workspace/Viary/ml/text2emotion.py \"${sentence}\"`;
    const out = execSync(command);    
    // replace single quote
    // ref: https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/JSON/parse#json.parse_%E3%81%AF%E5%8D%98%E4%B8%80%E5%BC%95%E7%94%A8%E7%AC%A6%E3%82%92%E8%A8%B1%E5%AE%B9%E3%81%97%E3%81%AA%E3%81%84
    const outStr = out.toString().replace(/'/g, '"');
    console.log(outStr);
    return JSON.parse(outStr);
  }
}
