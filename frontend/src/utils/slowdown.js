export function slowdown(time, promise){
    let timer = new Promise((resolve) => window.setTimeout(() => resolve(time), time));
    return new Promise((resolve, reject) => {
        promise.then(value => timer.then(() => resolve(value)), error => timer.then(() => reject(error)))
    });
}
