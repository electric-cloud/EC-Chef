my %DownloadCookbookFromRepository = (
    label       => "Chef - Download Cookbook From Repository",
    procedure   => "DownloadCookbookFromRepository",
    description => "Download a specific cookbook from the Opscode repository",
    category    => "Resource Management"
);

my %InstallCookbookOnClient = (
    label       => "Chef - Install Cookbooks On Client",
    procedure   => "InstallCookbookOnClient",
    description => "Install a specific cookbook on a Chef client",
    category    => "Resource Management"
);

my %UploadCookbooksToServer = (
    label       => "Chef - Upload Cookbooks To Server",
    procedure   => "UploadCookbooksToServer",
    description => "Upload cookbooks to the Chef server",
    category    => "Resource Management"
);

my %AddRecipesToNodeRunList = (
    label       => "Chef - Add Recipes To Node RunList",
    procedure   => "AddRecipesToNodeRunList",
    description => "Add recipes to a node run-list",
    category    => "Resource Management"
);

my %RunChefClient = (
    label       => "Chef - Run Chef Client",
    procedure   => "RunChefClient",
    description => "Run the chef-client command",
    category    => "Resource Management"
);


$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-Chef - DownloadCookbookFromRepository");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Chef - Download Cookbooks From Repository");

$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-Chef - InstallCookbookOnClient");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Chef - Install Cookbook On Client");

$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-Chef - UploadCookbooksToServer");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Chef - Upload Cookbooks To Server");

$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-Chef - AddRecipesToNodeRunList");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Chef - Add Recipes To Node RunList");

$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-Chef - RunChefClient");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Chef - Run Chef Client");

@::createStepPickerSteps = (\%DownloadCookbookFromRepository, \%InstallCookbookOnClient, \%UploadCookbooksToServer, \%AddRecipesToNodeRunList, \%RunChefClient);

