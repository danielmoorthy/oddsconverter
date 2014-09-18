use Test::More (tests => 17);

use_ok('OddsConverter');

subtest 'even money' => sub {
    my $oc = new_ok('OddsConverter' => [probability => 0.5]);
    is($oc->decimal_odds, '2.00', 'Even money decimal odds are 2.00');
    is($oc->roi,          '100%', 'Even money ROI is 100%');
};

subtest 'no chance' => sub {
    my $oc = new_ok('OddsConverter' => [probability => 0]);
    is($oc->decimal_odds, 'Inf.', 'No chance decimal odds are infinite');
    is($oc->roi,          'Inf.', 'No chance ROI is infinite');
};

subtest 'sure thing' => sub {
    my $oc = new_ok('OddsConverter' => [probability => 1]);
    is($oc->decimal_odds, '1.00', 'Sure thing decimal odds are 1.00');
    is($oc->roi,          '0%',   'Sure thing ROI is 0%');
};

subtest 'unlikely' => sub {
    my $oc = new_ok('OddsConverter' => [probability => 0.1]);
    is($oc->decimal_odds, '10.00', 'An unlikely event decimal odds might be 10.00');
    is($oc->roi,          '900%',  'An unlikely event ROI might be 900%');
};

subtest 'likely' => sub {
    my $oc = new_ok('OddsConverter' => [probability => 0.8]);
    is($oc->decimal_odds, '1.25', 'A likely event decimal odds might be 1.25');
    is($oc->roi,          '25%',  'A likely event ROI might be 25%');
};

subtest 'rounded' => sub {
    my $oc = new_ok('OddsConverter' => [probability => 0.6]);
    is($oc->decimal_odds, '1.67', 'Standard rounding rules apply for repeating decimal odds');
    is($oc->roi,          '67%',  'Standard rounding rules apply for ROI, as well');
};

subtest 'even money decimal odds' => sub {
    my $oc = new_ok('OddsConverter' => [decimal_odds => 2]);
    is($oc->probability,  '0.50', 'Even money probability is 0.50');
    is($oc->roi,          '100%', 'Even money ROI is 100%');
    is($oc->display_result, undef, 'display the display');
};

subtest 'sure thing decimal odds' => sub {
    my $oc = new_ok('OddsConverter' => [decimal_odds => 1]);
    is($oc->probability,  '1.00', 'Sure thing probability is 1.00');
    is($oc->roi,          '0%',   'Sure thing ROI is 0%');
    is($oc->display_result, undef, 'display the display');
};

subtest 'unlikely decimal odds' => sub {
    my $oc = new_ok('OddsConverter' => [decimal_odds => 10]);
    is($oc->probability,  '0.10', 'An unlikely event probability might be 0.10');
    is($oc->roi,          '900%',  'An unlikely event ROI might be 900%');
    is($oc->display_result, undef, 'display the display');
};

subtest 'likely decimal odds' => sub {
    my $oc = new_ok('OddsConverter' => [decimal_odds => 1.25]);
    is($oc->probability,  '0.80', 'A likely event probability might be 0.80');
    is($oc->roi,          '25%',  'A likely event ROI might be 25%');
    is($oc->display_result, undef, 'display the display');
};

subtest 'rounded decimal odds' => sub {
    my $oc = new_ok('OddsConverter' => [decimal_odds=> 1.67]);
    is($oc->probability,  '0.60', 'Standard rounding rules apply for probability might be 0.60');
    is($oc->roi,          '67%',  'Standard rounding rules apply for ROI, might be 67%');
    is($oc->display_result, undef, 'display the display');
};

subtest 'even money roi' => sub {
    my $oc = new_ok('OddsConverter' => [roi => 100]);
    is($oc->probability,  '0.50', 'Even money probability is 0.50');
    is($oc->decimal_odds, '2.00', 'Even money decimal_odds is 2.00');
    is($oc->display_result, undef, 'display the display');
};

subtest 'sure thing roi' => sub {
    my $oc = new_ok('OddsConverter' => [roi => 0]);
    is($oc->probability,  '1.00', 'Sure thing probability is 1.00');
    is($oc->decimal_odds, '1.00',   'Sure thing decimal odds is 1.00');
    is($oc->display_result, undef, 'display the display');
};

subtest 'unlikely roi' => sub {
    my $oc = new_ok('OddsConverter' => [roi => 900]);
    is($oc->probability,  '0.10', 'An unlikely event probability might be 0.10');
    is($oc->decimal_odds, '10.00','An unlikely event decimal_odds might be 10.00');
    is($oc->display_result, undef, 'display the display');
};

subtest 'likely roi' => sub {
    my $oc = new_ok('OddsConverter' => [roi => 25]);
    is($oc->probability,  '0.80', 'A likely event probability might be 0.80');
    is($oc->decimal_odds, '1.25',  'A likely event decimal_odds might be 1.25');
    is($oc->display_result, undef, 'display the display');
};

subtest 'rounded roi' => sub {
    my $oc = new_ok('OddsConverter' => [roi => 67]);
    is($oc->probability,  '0.60', 'Standard rounding rules apply. probability might be 0.60');
    is($oc->decimal_odds, '1.67', 'Standard rounding rules apply for decimal_odds might be 1.67');
    is($oc->display_result, undef, 'display the display');
};
