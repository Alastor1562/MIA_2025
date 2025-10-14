%res=downloadValues('grumab.mx','2016-05-26', '2017-07-05','d','history');
%res.Close example of how to call the Close column
function response=downloadValues(subyacente, start_date,end_date,fr,data_type)

% fr='d'  Frequency: 'd' = daily, 'w'=weekly, 'm'= monthly  
% data_type='history' types: 'history'=historical prices, 'div'=dividends,  'split'= stock splits

% subyacente='grumab.mx';  assets or underlying asset
% end_date='2017-07-04';
% start_date='2016-05-26';

t = datetime(start_date);
start_date=posixtime(t);
t = datetime(end_date);
end_date=posixtime(t);

url=['https://query1.finance.yahoo.com/v7/finance/download/',subyacente,'?period1=',num2str(start_date),'&period2=',num2str(end_date),'&interval=1',fr,'&events=',data_type,'&crumb=WoTu8cwg8VU'];

options = weboptions('ContentType','table', 'UserAgent', 'Mozilla/5.0');
    try
        response = rmmissing(webread(url, options));
    catch ME
        data = [];
        warning(['Identifier: ', ME.identifier, 'Message: ', ME.message])
end