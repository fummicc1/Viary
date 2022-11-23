import { Controller, Get, Query } from '@nestjs/common';
import { Text2emotionService } from './text2emotion.service';

@Controller('text2emotion')
export class Text2emotionController {
    constructor(private readonly text2emotionService: Text2emotionService) { }
    @Get()
    fetch(@Query('text') text: string): string {
        const res = this.text2emotionService.execute(text);
        return res;
    }
}
