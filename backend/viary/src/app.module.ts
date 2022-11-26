import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { Text2emotionController } from './text2emotion/text2emotion.controller';
import { Text2emotionService } from './text2emotion/text2emotion.service';

@Module({
  imports: [],
  controllers: [AppController, Text2emotionController],
  providers: [AppService, Text2emotionService],
})
export class AppModule {}
