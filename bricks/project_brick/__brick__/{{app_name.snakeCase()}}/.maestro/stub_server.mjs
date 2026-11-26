// Dependency-free stub of the /todos API (in-memory, resets on restart).
//   node .maestro/stub_server.mjs [port]      (default 8080)
// Matches the contract in lib/features/example/data/data_sources/remote.
import http from 'node:http';

const port = Number(process.argv[2] ?? 8080);
let seq = 1;
const todos = [];
const add = (title) => {
  const t = { id: String(seq++), title, is_done: false, updated_at: new Date().toISOString() };
  todos.push(t);
  return t;
};
add('Stub todo');

http.createServer((req, res) => {
  let raw = '';
  req.on('data', (c) => (raw += c));
  req.on('end', () => {
    const [, id] = req.url.split('?')[0].match(/\/todos\/?([^/]*)$/) ?? [];
    if (id === undefined) return send(res, 404, { error: 'not found' });
    const body = raw ? JSON.parse(raw) : {};
    const item = todos.find((t) => t.id === id);
    if (req.method === 'GET' && !id) return send(res, 200, { items: todos, has_more: false });
    if (req.method === 'POST' && !id) return send(res, 201, add(body.title));
    if (!item) return send(res, 404, { error: 'not found' });
    if (req.method === 'GET') return send(res, 200, item);
    if (req.method === 'PATCH') return send(res, 200, Object.assign(item, body, { updated_at: new Date().toISOString() }));
    if (req.method === 'DELETE') { todos.splice(todos.indexOf(item), 1); return send(res, 204); }
    send(res, 405, { error: 'method not allowed' });
  });
}).listen(port, () => console.log(`stub /todos on :${port}`));

function send(res, code, json) {
  res.writeHead(code, { 'content-type': 'application/json' });
  res.end(json === undefined ? '' : JSON.stringify(json));
}
