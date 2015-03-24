@::gMatchers = (
  {
   id =>        "ChefEncounteredError",
   pattern =>          q{.*(Chef\sencountered\san\serror.*)},
   action =>           q{&addSimpleError("ChefEncounteredError", "$1");setProperty("outcome", "error" );},
  },
  {
   id =>        "AuthorizationError",
   pattern =>          q{.*(Your\svalidation\sclient\sis\snot\sauthorized\sto\screate\sthe\sclient\sfor\sthis\snode.*)},
   action =>           q{&addSimpleError("AuthorizationError", "$1");setProperty("outcome", "error" );},
  },
  {
   id =>        "CmdNotFound",
   pattern =>          q{(.*\scommand\snot\sfound.*)},
   action =>           q{&addSimpleError("CmdNotFound", "$1");setProperty("outcome", "error" );},
  },
  {
   id =>        "BuildFailed",
   pattern =>          q{.*Error:(.*)|.*(The\ssystem\scannot\sfind\sthe\spath\sspecified).*|.*Can't.*},
   action =>           q{&addSimpleError("BuildFailed", "Error $1");setProperty("outcome", "error" );},
  },  
  {
   id =>        "SyntaxError",
   pattern =>          q{.*(Syntax\serror).*},
   action =>           q{&addSimpleError("SyntaxError", "$1");setProperty("outcome", "error" );},
  },
  {
   id =>        "GenericError",
   pattern =>          q{.*Could\snot\s(.*)},
   action =>           q{&addSimpleError("GenericError", "Could not $1");setProperty("outcome", "error" );},
  },
  {
   id =>        "FailError",
   pattern =>          q{.*(Fail).*},
   action =>           q{&addSimpleError("FailError", "$1");setProperty("outcome", "error" );},
  },
  {
   id =>        "run list",
   pattern =>          q{.*Run\sList\sis\s(.*)},
   action =>           q{&replaceSummary("Processing run list $1 ...");},
  },
  {
   id =>        "chef completed",
   pattern =>          q{Chef\sRun\scomplete\sin(.*)},
   action =>           q{&replaceSummary("Chef run completed in $1");},
  },
);

sub addSimpleError {
    my ($name, $customError) = @_;
    if(!defined $::gProperties{$name}){
        setProperty ($name, $customError);
        replaceSummary ($customError);
    }
}

sub replaceSummary($)
{
    my ($str) = @_;
    setProperty("summary", $str);
    setProperty("/myParent/summary", $str);
}
