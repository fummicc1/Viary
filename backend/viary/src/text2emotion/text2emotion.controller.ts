import { Controller, Get, Query } from '@nestjs/common';
import { Text2emotionService } from './text2emotion.service';

@Controller('text2emotion')
export class Text2emotionController {
  constructor(private readonly text2emotionService: Text2emotionService) {}
  @Get()
  fetch(@Query('text') text: string, @Query('lang') lang: string): string {
    text = text.replace(/\n/g, ". ");
    console.log(text);
    const result = this.text2emotionService.execute(text, lang);
    const response = {
      results: result,
    };
    return JSON.stringify(response);
  }
}
