# Viary

Viary is a voicy diary application with automatic sentiment analysis feature. (currently, working on only iOS.)

<img src="https://user-images.githubusercontent.com/44002126/236610406-35238593-f4b3-4dd9-817d-4294bb9b06db.png" width=320>


## Demo



https://user-images.githubusercontent.com/44002126/233632663-9e384b7d-149e-463f-b125-854bd5ca9a55.MP4

## Pages

### ViaryList

- like a timeline to see diaries you created

### CreateViary

- you can write in your diary in English (will support Japanese in the future)

### EditViary

- you can edit message in your diary and recorded sentiment amount as well



## Tech

The followings are what dependencies in Viary.

- [Swift Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture)
- [Swift CoreML Transformers](https://github.com/huggingface/swift-coreml-transformers)
- [HuggingFace Model: j-hartmann/emotion-english-distilroberta-base](https://huggingface.co/j-hartmann/emotion-english-distilroberta-base)
