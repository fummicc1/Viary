import { Controller, Get, Query } from '@nestjs/common';
import { Text2emotionService } from './text2emotion.service';

@Controller('text2emotion')
export class Text2emotionController {
    constructor(private readonly text2emotionService: Text2emotionService) { }
    @Get()
    fetch(@Query('text') text: string): string {
        const texts = text.split(".");
        let allResult = [];
        console.log("texts:", texts);
        for (const text of texts) {
            const result = this.text2emotionService.execute(text);
            allResult.push(result);
        }
        const response = {
            "results": allResult,
        };
        return JSON.stringify(response);
    }
}
