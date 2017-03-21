# CLI tool around [sha1collisiondetection library](https://github.com/cr-marcstevens/sha1collisiondetection)
The tools provided with the sha1collisiondetection library force you to parse the output to check if a collision has been found.

## Usage
```shell
 $ ./sha1collisiondetector non-shattered.pdf
 $ echo $?
 0
```
```shell
 $ ./sha1collisiondetector shattered.pdf
 $ echo $?
 3
```
```shell
 $ curl https://example.com | ./sha1collisiondetector
 $ echo $?
 0
```
