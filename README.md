## WETH contract foundry test

## Usage

### Build

```shell
$ forge build
```

### Test

Test entire weth test cases
```shell
$ forge test --mc NonftReceiver
```
Or test specific case via
```shell
$ forge test --mc NonftReceiver --mt test_OnERC721Received
```