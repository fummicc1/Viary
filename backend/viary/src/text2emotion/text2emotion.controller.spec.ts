import { Test, TestingModule } from '@nestjs/testing';
import { Text2emotionController } from './text2emotion.controller';

describe('Text2emotionController', () => {
  let controller: Text2emotionController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [Text2emotionController],
    }).compile();

    controller = module.get<Text2emotionController>(Text2emotionController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
