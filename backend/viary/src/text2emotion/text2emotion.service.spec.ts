import { Test, TestingModule } from '@nestjs/testing';
import { Text2emotionService } from './text2emotion.service';

describe('Text2emotionService', () => {
  let service: Text2emotionService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [Text2emotionService],
    }).compile();

    service = module.get<Text2emotionService>(Text2emotionService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
