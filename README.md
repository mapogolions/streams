## Project status : in progress


### Introduction

The simple library for event streams. OOP programming consider a stream as an object. On the other hand, in functional programming a stream is high order function.

#### OOP (zen-observable)

```javascript
const unsubscribe = Observable.of(1, 2, 3)
  .map(x => x + 1)
  .filter(x => x % 2 !== 0)
  .subscribe({
    next: value => console.log(value),
    error: err => console.error(err),
    done: () => console.log('done')
  });
```

#### FP

```f#
let unsubscribe = [1; 2; 3]
  |> Stream.Async.of_list ~delay:1000
  |> Stream.map (fun x -> x + 1)
  |> Stream.filter (fun x -> x mod 2 <> 0)
  |> Stream.subscribe (fun x -> x |> string_of_int |> print_endline)
```

------------------------
### Setup

#### Build
```
npm run build
```

#### Watch

```
npm run watch
```

#### Editor
If you use `vscode`, Press `Windows + Shift + B` it will build automatically