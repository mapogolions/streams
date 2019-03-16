# STATE : active developing :) 


## Introduction

### OOP (zen-observable)

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

### FP 

```ml
let unsubscribe = 
  Stream.Async.of_list 1000 [1; 2; 3]
  |> Stream.map (fun x -> x + 1)
  |> Stream.filter (fun x -> x mod 2 <> 0)
  |> Stream.subscribe (fun x -> x |> string_of_int |> print_endline)
```



### Build
```
npm run build
```

### Watch

```
npm run watch
```

### Editor
If you use `vscode`, Press `Windows + Shift + B` it will build automatically