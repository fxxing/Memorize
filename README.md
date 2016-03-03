# Memorize
Simple iOS App to memorize Japanese vocabularies.

It's designed to fit my requirement, which is memorize Japanese words. Howevent, it can be easily modified to memorize anything.

# Screenshots
![screen1](https://raw.githubusercontent.com/fxxing/Memorize/master/Screenshots/screen1.png)
![screen2](https://raw.githubusercontent.com/fxxing/Memorize/master/Screenshots/screen2.png)
![screen3](https://raw.githubusercontent.com/fxxing/Memorize/master/Screenshots/screen3.png)
![screen4](https://raw.githubusercontent.com/fxxing/Memorize/master/Screenshots/screen4.png)
![screen5](https://raw.githubusercontent.com/fxxing/Memorize/master/Screenshots/screen5.png)
![screen6](https://raw.githubusercontent.com/fxxing/Memorize/master/Screenshots/screen6.png)
![screen7](https://raw.githubusercontent.com/fxxing/Memorize/master/Screenshots/screen7.png)

# Methodology

Based on `The Ebbinghaus Forgetting Curve`. It split the vocabulary to `list`s, each `list` contains 100 words (can be changed). It will schedule the list to be memorized on day 1, 2, 3, 5, 8, 16 and 31.

# Usage
It has 3 modes: `Learn`, `Dictate` and `Test`.

### Learn Mode
Show `Kana`, `Japanese`, `Part of speech` and `Chinese`. Simple mode to memorize.

### Dictate Mode
Play the audio and try to recall the  `Kana`, `Japanese`, `Part of speech` and `Chinese`. 

### Test Mode
Show `Chinese` and try to recall the  `Kana`, `Japanese`, and `Part of speech`. 


# Customize

change `LIST_PER_DAY` and `WORD_PER_LIST` in `DataManager.swift`
