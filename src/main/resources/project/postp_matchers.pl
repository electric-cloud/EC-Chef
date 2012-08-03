@::gMatchers = (
  {
   id =>        "BuildFailed",
   pattern =>          q{.*Error:(.*)|.*(The\ssystem\scannot\sfind\sthe\spath\sspecified).*|.*Can't.*},
   action =>           q{&addSimpleError("BuildFailed", "Error $1");setProperty("outcome", "error" );updateSummary();},
  },  
  {
   id =>        "SyntaxError",
   pattern =>          q{.*(Syntax\serror).*},
   action =>           q{&addSimpleError("SyntaxError", "$1");setProperty("outcome", "error" );updateSummary();},
  },
  {
   id =>        "GenericError",
   pattern =>          q{.*Could\snot\s(.*)},
   action =>           q{&addSimpleError("GenericError", "Could not $1");setProperty("outcome", "error" );updateSummary();},
  },
  {
   id =>        "FailError",
   pattern =>          q{.*(Fail).*},
   action =>           q{&addSimpleError("FailError", "$1");setProperty("outcome", "error" );updateSummary();},
  },  
);

sub addSimpleError {
    my ($name, $customError) = @_;
    if(!defined $::gProperties{$name}){
        setProperty ($name, $customError);
    }
}

sub updateSummary() {
    my $summary = (defined $::gProperties{"BuildFailed"}) ? $::gProperties{"BuildFailed"} . "\n" : "";
    $summary .= (defined $::gProperties{"SyntaxError"}) ? $::gProperties{"SyntaxError"} . "\n" : "";
    $summary .= (defined $::gProperties{"GenericError"}) ? $::gProperties{"GenericError"} . "\n" : "";
    $summary .= (defined $::gProperties{"results"}) ? $::gProperties{"results"} . "\n" : "";

    setProperty ("summary", $summary);
}