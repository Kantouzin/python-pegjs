/* Python 3.7 Subset Grammar */
/* https://docs.python.org/3.7/reference/grammar.html */

{
  var indentStack = []

  function printStack(tab) {
    console.log("  tab  : ", tab);
    console.log("  stack: ", indentStack);
  }
}

// ========== Grammar ===========

file_input
  = s:(stmt / NEWLINE)* EOF
    { return s.filter(value => value != "\n"); }

single_input
  = simple_stmt
  / compound_stmt NEWLINE
  / NEWLINE

stmt
  = simple_stmt / compound_stmt

simple_stmt
  = s:small_stmt NEWLINE //(';' small_stmt)* ';'? NEWLINE
    { return s; }

small_stmt
  = pass_stmt
  /* / expr_stmt */

pass_stmt
  = 'pass' {return ["pass"];}

compound_stmt
  = if_stmt
  / for_stmt
  /* / while_stmt */

if_stmt
  = 'if' __ t:$test ':' _ s:suite
    ('elif' test ':' suite)*
    ('else' ':' suite)?
    { return ["if", t, s]; }

for_stmt
  = 'for' __ e:exprlist __ 'in' __ t:testlist _ ':' s:suite
    // ('else' ':' suite)?
    { return  ["for", e, t, s]; }

suite
  = simple_stmt
  / block

block
  = NEWLINE INDENT head:(s:stmt {return s;}) tail:(SAMEDENT s:stmt {return s;})* DEDENT
    {
      var result = [];
      [head].concat(tail).forEach(function(element) {
        result.push(element);
      });

      return result;
    }

test
  = or_test
    /* ('if' or_test 'else' test)? / lambdef */

or_test
  = and_test ('or' and_test)*

and_test
  = not_test ('and' not_test)*

not_test
  = 'not' not_test
  / comparison

comparison
  = expr (comp_op expr)*

comp_op
  = '<' / '>' / '==' / '>=' / '<=' / '<>' / '!=' / 'in' / 'not' 'in' / 'is' / 'is' / 'not'

star_expr
  = '*' _ expr

expr
  = xor_expr ('|' xor_expr)*

xor_expr
  = and_expr ('^' and_expr)*

and_expr
  = shift_expr ('&' shift_expr)*

shift_expr
  = arith_expr (('<<' / '>>') arith_expr)*

arith_expr
  = term (('+' / '-') term)*

term
  = factor (('*' / '@' / '/' / '%' / '//') factor)*

factor
  = ('+' / '-' / '~') factor
  / power

power
  = atom_expr ('**' factor)?

atom_expr
  = atom
/*   = 'await'? atom trailer* */

atom
  = NAME / NUMBER / STRING+ / 'None' / 'True' / 'False'

exprlist
  = (expr / star_expr) (_ ',' _ (expr / star_expr))* (_ ',' _)?

testlist
  = test (_ ',' _ test)* (_ ',' _)?

// =========== Token ============

SAMEDENT
  = i:tabs &{
      console.log("\nSAMEDENT");
      printStack(i);
      console.log("  result: ", i.length === indentStack.length);
      return i.length === indentStack.length;
    }
    {
      console.log("s:", i.length, " level:", indentStack.length);
    }

INDENT
  = i:tabs &{
      console.log("\nINDENT");
      printStack(i);
      return i.length > indentStack.length;
    }
    {
      indentStack.push("");
      console.log("i:", i.length, " level:", indentStack.length);
    }

DEDENT
= &(i:tabs &{
      console.log("\nDEDENT");
      printStack(i);
      return i.length < indentStack.length;
    }
    {
      for (var j = i.length; j < indentStack.length; j++) {
        indentStack.pop();
      }
      console.log("d:", i.length + 1, " level:", indentStack.length);
    }
  )

tabs
  = t:tab* { return t; }

tab
  = ("\t" / "    ") { return ""; }

NAME
  = head:[a-zA-Z] tail:[a-zA-Z0-9]*
    { return head + tail.join(""); }

STRING
  = '"' stringitem* '"' / "'" stringitem* "'"

stringitem
  = stringchar / escapeseq

stringchar
  = [^\\]

escapeseq
  = "\\" [\\'"abfnrtv]

NUMBER
  = [1-9][0-9]*

NEWLINE
  = '\r\n' / '\n' / '\r'

__
  = [ ]+

_
  = [ ]*

EOF
  = !.

EOL
  = "\r\n" / "\n" / "\r"
