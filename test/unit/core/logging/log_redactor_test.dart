import 'package:flutter_all_template/core/common/domain/services/logger/log_redactor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const mask = LogRedactor.mask;

  test('masks bearer tokens', () {
    expect(
      LogRedactor.redact('Authorization: Bearer abc.DEF-123_x='),
      isNot(contains('abc.DEF')),
    );
  });

  test('masks JWT-looking strings anywhere', () {
    const jwt =
        'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMjM0NTY3ODkwIn0.dozjgNryP4J3jVmNHl0w5N_XgL0n3I9PlFUP0THsR8U';
    final out = LogRedactor.redact('session $jwt done');
    expect(out, isNot(contains('eyJ')));
    expect(out, contains(mask));
  });

  test('masks key=value secrets in query strings / form bodies', () {
    final out = LogRedactor.redact(
      'https://x.io/login?user=bob&password=hunter2&token=t0k&refresh_token=r',
    );
    expect(out, contains('user=bob'));
    expect(out, isNot(contains('hunter2')));
    expect(out, isNot(contains('t0k')));
    expect(out, contains('password=$mask'));
    expect(out, contains('refresh_token=$mask'));
  });

  test('masks JSON secret fields', () {
    final out = LogRedactor.redact(
      '{"email":"a@b.c","password":"hunter2","accessToken":"xyz"}',
    );
    expect(out, contains('"email":"a@b.c"'));
    expect(out, isNot(contains('hunter2')));
    expect(out, isNot(contains('xyz')));
  });

  test('leaves ordinary text alone', () {
    const text = 'Loaded 12 todos from /api/todos in 30 ms';
    expect(LogRedactor.redact(text), text);
  });

  test('redactHeaders masks auth and cookie headers case-insensitively', () {
    final out = LogRedactor.redactHeaders({
      'authorization': 'Bearer x',
      'Cookie': 'sid=1',
      'Set-Cookie': 'sid=2',
      'Accept': 'application/json',
    });
    expect(out['authorization'], mask);
    expect(out['Cookie'], mask);
    expect(out['Set-Cookie'], mask);
    expect(out['Accept'], 'application/json');
  });
}
